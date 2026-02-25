#include "BGS.h"
#include "Filtros.h"
#include "MemHandler.h"
#include <algorithm>
#include <cctype>
#include <ctime>
#include <device_launch_parameters.h>
#include <iostream>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <vector>
int main(int argc, char** argv)
{

    if (argc < 3) {
        std::cout << "Uso: BGS caminho_para_video tamanho_buffer" << std::endl;
        return -1;
    }
    cv::VideoCapture in;
    if (std::isdigit(argv[1][0]))
        in.open(std::atoi(argv[1]));
    else
        in.open(argv[1]);
    if (!in.isOpened()) {
        std::cout << argv[1] << " não pode ser aberto" << std::endl;
        return -2;
    }

    int buff_size = atoi(argv[2]);

    int cols = (int)in.get(cv::CAP_PROP_FRAME_WIDTH);
    int rows = (int)in.get(cv::CAP_PROP_FRAME_HEIGHT);

    unsigned char* d_framein;
    unsigned char* d_framet;
    unsigned char* d_frameint;
    unsigned char* d_fore;
    unsigned char* d_buffer;

    int pos = 0;
    alloc(d_framein, d_framet, d_frameint, d_fore, d_buffer, cols, rows, buff_size);

    cv::namedWindow("Original", cv::WINDOW_NORMAL);
    cv::namedWindow("Resultado", cv::WINDOW_NORMAL);

    std::vector<float> tempos;
    const float kernel[25] = { 0.0037, 0.0147, 0.0256, 0.0147, 0.0037,
                               0.0147, 0.0586, 0.0952, 0.0586, 0.0147,
                               0.0256, 0.0952, 0.1502, 0.0952, 0.0256,
                               0.0037, 0.0147, 0.0256, 0.0147, 0.0037,
                               0.0147, 0.0586, 0.0952, 0.0586, 0.0147 };

    cv::Mat frame;
    in >> frame;
    cv::Mat fore(frame.size(), CV_8U);

    bool begin = true;
    clock_t temp;
    float secs;
    char k = 0;
    while (!frame.empty() && k != 27) {
        imshow("Original", frame);

        temp = clock();

        cudaMemcpy(d_framein, frame.ptr<unsigned char>(), sizeof(uchar) * cols * rows, cudaMemcpyHostToDevice);

        rgb_to_greyscale(d_framein, d_frameint, rows, cols);
        gaussian_blur(d_frameint, d_framet, rows, cols, kernel, 25);

        BGS(d_buffer, buff_size, d_framet, cols * rows, d_fore);

        putInBuffer(d_buffer, d_framet, cols, rows, buff_size, pos);
        cudaMemcpy(fore.ptr<unsigned char>(), d_fore, sizeof(uchar) * cols * rows, cudaMemcpyDeviceToHost);

        temp = clock() - temp;
        secs = (float)temp / CLOCKS_PER_SEC;

        imshow("Resultado", fore);

        pos++;
        if (pos > buff_size) {
            pos = 0;
            begin = true;
        }

        if (begin)
            tempos.push_back(secs);

        k = cv::waitKey(1);

        in >> frame;
    }

    in.release();
    frame.release();
    fore.release();
    dealloc(d_framein, d_framet, d_frameint, d_fore, d_buffer, cols, rows, buff_size);

    for (float& f : tempos) {
        std::cout << f << std::endl;
    }

    return 0;
}

#include <iostream>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <cstdlib>

using namespace std;
using namespace cv;

int main(int argc, char** argv){
	if(argc<3){
		cout<<"É necessário especificar caminho para vídeo e o tamanho do buffer"<<endl;
		return -1;
	}
	
	Mat frame;
	VideoCapture cap(argv[1]);
	int max = atoi(argv[2]);
	Mat* buffer = new Mat[max];
	Mat back, fore;
	int i = 0;

	do{
		cap >> frame;
		GaussianBlur(frame,frame,Size(7,7),0.88);
		frame.copyTo(buffer[i]);
		i++;
	}while(i<max);
	namedWindow("Teste",WINDOW_AUTOSIZE);
	namedWindow("Back", WINDOW_AUTOSIZE);
	back = Mat::zeros(frame.size(),frame.type());
	i = 0;
	char k = 'a';
	cap>>frame;
	while(k!=27&&!frame.empty()){
		back.release();
		back = Mat::zeros(frame.size(),frame.type());
		for(int j = 0; j<max; j++){
			back += buffer[i]/max;
		}
		imshow("Back",back);
		cap >>frame;
		GaussianBlur(frame,frame,Size(7,7),0.88);
		fore = frame - back;
		imshow("Teste",fore);
		frame.copyTo(buffer[i]);
		i++;
		if(i==max) i = 0;
		k = waitKey(30);
	}
	cap.release();
	return 0;
}

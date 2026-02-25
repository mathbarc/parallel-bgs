cmake_minimum_required(VERSION 3.20)
project("ParallelBGS" LANGUAGES CXX CUDA)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

find_package(CUDA REQUIRED)
find_package(OpenCV COMPONENTS videoio highgui REQUIRED)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include ${CUDA_INCLUDE_DIRS} ${OpenCV_INCLUDE_DIRS})

file(GLOB KRN_SOURCES ${CMAKE_CURRENT_LIST_DIR}/kernel/*.cu)

add_library(bgsKernels STATIC ${KRN_SOURCES})

file(GLOB BGS_SOURCES ${CMAKE_CURRENT_LIST_DIR}/source/main.cpp)
add_executable(${PROJECT_NAME} ${BGS_SOURCES})
target_link_libraries(${PROJECT_NAME} bgsKernels ${CUDA_LIBRARIES} ${OpenCV_LIBRARIES})


FROM ubuntu:bionic

RUN apt-get update
RUN apt-get install -y python-pip python3-pip
RUN python2 -m pip install -U pip
RUN python3 -m pip install -U pip

RUN python3 -m pip install -U trollius
RUN python3 -m pip install -U rosdep rosinstall-generator wstool rosinstall
RUN rosdep init && \
    rosdep update
RUN mkdir -p ~/ros/melodic/src
RUN cd ~/ros/melodic && \
    rosinstall_generator ros_comm --rosdistro melodic \
    --deps > melodic-ros_comm.rosinstall

RUN apt-get install -y git

ENV DEBIAN_FRONTEND=noninteractive

RUN cd ~/ros/melodic && \
    wstool init -j4 src melodic-ros_comm.rosinstall

ENV ROS_PYTHON_VERSION=3
RUN python3 -m pip install -U catkin-pkg catkin-pkg-modules empy
RUN python2 -m pip install -U catkin-pkg catkin-pkg-modules empy

RUN echo $ROS_PYTHON_VERSION
RUN cd ~/ros/melodic && \
    rosdep install --from-paths src \
    --ignore-src --rosdistro melodic -y
RUN cd ~/ros/melodic && \
    ./src/catkin/bin/catkin_make_isolated --install \
    -DCMAKE_BUILD_TYPE=Release






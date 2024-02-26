FROM python:3.10-bullseye

RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        git \
        build-essential \
        dpkg-dev \
        ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
RUN git clone https://github.com/ggerganov/whisper.cpp.git
WORKDIR whisper.cpp

# openvino
WORKDIR models
RUN pip install -r requirements-openvino.txt

# download whisper.cpp setup
RUN python convert-whisper-to-openvino.py --model base.en
ENV PATH="/ve/bin:$PATH"
RUN . ./path/to/l_openvino_toolkit_ubuntu22_2023.0.0.10926.b4452d56304_x86_64/setupvars.sh

# build project
RUN cmake -B build -DWHISPER_OPENVINO=1
RUN cmake --build build -j --config Release

# serving
RUN make server

EXPOSE 8085

# Run app.py when the container launches ./server -m models/ggml-medium-32-2.en.bin
CMD ["./server", "-m", "./models/ggml-base.en.bin", "-p", "2", "--host", "0.0.0.0", "--port", "8085", "--convert", "-debug", "-sow"]
FROM python:3.10-bullseye
# ffmpeg \
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
RUN make server

# download whisper.cpp setup
RUN wget https://huggingface.co/distil-whisper/distil-medium.en/resolve/main/ggml-medium-32-2.en.bin -P ./models

# Run app.py when the container launches ./server -m models/ggml-medium-32-2.en.bin
CMD ["./server", "-m", "./models/ggml-medium-32-2.en.bin", "-p", "4", "--host", "0.0.0.0", "--port", "8585", "--convert"]
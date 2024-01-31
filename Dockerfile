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


# download whisper.cpp setup
#RUN wget https://huggingface.co/distil-whisper/distil-medium.en/resolve/main/ggml-medium-32-2.en.bin -P ./models
RUN ./models/download-ggml-model.sh small.en

# quantize
RUN make quantize
RUN ./quantize models/ggml-small.en.bin models/ggml-small-q5_0.bin q5_0
RUN rm -rf models/ggml-small.en.bin


RUN make server
EXPOSE 8085
# Run app.py when the container launches ./server -m models/ggml-medium-32-2.en.bin
#CMD ["./server", "-m", "./models/ggml-medium-32-2-q5_0.bin", "-p", "8", "--host", "0.0.0.0", "--port", "8085", "--convert"]
CMD ["./server", "-m", "./models/ggml-small-q5_0.bin", "-p", "8", "--host", "0.0.0.0", "--port", "8085", "--convert"]
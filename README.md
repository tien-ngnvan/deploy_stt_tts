# deploy_stt_tts
Deploy whisper cpp

```docker
docker-compose down && docker-compose up
```

## run inference
```
curl localhost:8585/inference -H "Content-Type: multipart/form-data" -F file="@./samples/jfk.wav" -F temperature="0.2"  -F response-format="json"
```
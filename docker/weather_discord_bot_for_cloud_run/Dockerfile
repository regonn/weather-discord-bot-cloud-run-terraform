FROM nimlang/nim:1.4.6-alpine

# ライブラリが必要な場合
RUN nimble install dotenv -y

WORKDIR /nim

COPY . ./

RUN nim compile -d:ssl -d:release --verbosity:0 --hints:off main.nim

CMD ["./main"]
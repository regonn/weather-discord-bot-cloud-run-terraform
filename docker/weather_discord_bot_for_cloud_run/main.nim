import asynchttpserver, asyncdispatch, strutils, json, httpclient, dotenv, os

let env = initDotEnv()
env.load()

proc main {.async.} =
  var server = newAsyncHttpServer()
  let client = newHttpClient(timeout = 10000)
  proc cb(req: Request) {.async.} =
    if req.reqMethod == HttpGet and req.url.path == "/":
      let headers = {"Content-type": "text/json; charset=utf-8"}
      let responseJson = %*{"content": "Hello"}
      await req.respond(Http200, $responseJson, headers.newHttpHeaders())

    elif req.reqMethod == HttpGet and req.url.path == "/post_weather":
      let headers = {"Content-type": "text/json; charset=utf-8"}
      try:
        # 地域コード
        # http://www.jma.go.jp/bosai/common/const/area.json

        let
            response = request(client= client, url="https://www.jma.go.jp/bosai/forecast/data/overview_forecast/320000.json", httpMethod="GET", headers=newHttpHeaders())
            jsonNode = parseJson(response.body)
            text = jsonNode["text"].getStr()
            postBody = %*{"content": text}
        
        let headers = newHttpHeaders({
          "Content-Type": "application/json"
        })
        let discordResponse = request(client= client, url=getEnv("DISCORD_WEBHOOK_URL"), httpMethod="POST", headers=headers, body= $postBody)

        await req.respond(Http200, $postBody, newHttpHeaders())

      except Exception:
        let
            msg = getCurrentExceptionMsg()
            response = %*{"ErrorMessage": msg}

        await req.respond(Http400, $response, headers.newHttpHeaders())

    else:
      await req.respond(Http404, "Not found")

  waitFor server.serve(Port(8080), cb)

discard main()
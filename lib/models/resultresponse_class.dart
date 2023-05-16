class ResponseResult {
  bool ok = false;
  String msg = "";

  ResponseResult();
  ResponseResult.full(this.ok, this.msg);

  getFromAPI(Map<String, dynamic> respData) {
    ok = respData["ok"];
    msg = respData["msg"];
  }
}

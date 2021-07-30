from handler import hello

def test_hello():
    assert hello({}, '')['statusCode'] == 200
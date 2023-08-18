from hello import app

def test_healthcheck():
   response = app.test_client().get('/healthcheck')
   assert response.status_code == 200

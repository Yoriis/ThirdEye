
import cv2
from ultralytics import YOLO
import urllib.request
import numpy as np
import time
from firebase_admin import credentials
from firebase_admin import db
import firebase_admin

# URL of the camera 
url = 'http://192.168.105.68/cam-hi.jpg'
#firebase credentials 
firebase_cred = {
  "type": "service_account",
  "project_id": "finalproject-15cde",
  "private_key_id": "9beb4e351ba56574cd2d24a0ef9690c0a133695c",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC0zUyeHU4N2lpo\nbH2bnvHsVJ8pAeSUAN3lGrhgJvsKu3jP8vM74Z8OZXb7ut+Ma5YHDgTxntCf7VEW\nqkzzuGsLyBBf35wB3csKg04uN5RSE6UTQvUiPKse0LO/7cTuYKYojbgTOcZghfll\nGjInPkSxCwbl6z5ieqaPk1DAorZnuGTn7lXsJD342rsP93ghU04fuN01sPSzxDM0\nh0dCJtrzbW1oJT9H//pv9TNNigMi9UVtWcDcxCiXP0xnVyh4winCWmzjJrGQcRoa\neYQ9lMrbD87Q0BL9IpKTMS3T2NCZFdhNqVC9rnV+xjC//A45yP/O+pCprmsECBD0\nLytO5gctAgMBAAECggEADQoTYQHfC7u4MnjElFEhxHgT5Hq49/2aAzhqnLCjAVKk\n82ZjqWlrtbeWnbAMCE4IC2k07RIVnLsaUoaktx0RR0+98pQnZbEPwCnZHRcwEL1O\n9fUpxbbXZokJtalZvxFkWl9iK6zKhFKVOnfprw/cF2KitDlDjgmncope1A3IFvHD\nxNE8x8xR7ZJ62WRtdfcNTTBEhMWKhdKu7x8sO8StTtCHFngCTTwG+xGRZ7U59BUq\nZAESOOloS+6DCh8fUdpnTL31eiccm2ah+T9nykXnu4O3HtRWk01y9PQUaRbDu7G5\nlwDCPVou78mTgKdur3kNYVnooGV8AKF+0YrAgEdyEQKBgQDxQt1r0cUkNPWp157K\nLMcz4F2j47LrPNRl3nV+Uv31QrTvBTP2P1YnW1STqL+Myv51P+bDWEvtON9xzols\nxwgovzKzbqRhM0U8RiattTZWXORRy9II2p4726zhBL1Ku33gd+njvX/GUu607R2L\n9b4GcEfLGnnk31unIEFQG0rCpQKBgQC/2OZBi/jpFCs9QuSk1ayBJMI66nvzBYJF\nbOubqErvMkJ6fKogwC0FouIUpbRa66jLE7lV25VVRGL/NCItDt/UDKWPQZ5NTZYq\n6M27K717s2oltPEuXK+1gcIiVhk7CsSAZNOkdRHTtKEB5BiwM23bJwDgIwJZBP0J\njTdFfoQz6QKBgQDE5sxthat+zFY/AoJPANKnTRM/gcNxZ5j1duSvb65ir8mZVca9\nz51Ry6EwTcXfc4DPUpLUlUiKWCNM78KK67mF/92yQbeYuM5lzd8dYErzmyagd1d4\n8Gu58KSclVCkIHcwbs2NmAgjZWX6dZbqtmobOSHu6jHXkE9uC84iQdP3HQKBgQCv\nYNIFY7b1I9nvU+J/CVJ8cKUahNcwr32Kh+rOzkdKaTC6lpJUBDpkJ6XzaBP69enF\nU8+evHDElRLG59rCRBG74J/M2Rik5GN98Hp6O58poTdNJx8/2b1K+UcGap0AC3Td\nRs7vTZIxbbOubd1f3nPz3rD/NSHlTRkgjTbU0bZ7WQKBgANSY4eT4M6fTMfuHTfT\nGzAkt/B2V7rWDcqDNUsfb55qvuH88lvU7TpdjSpW0MGL6ySwNm/EzusKhyK3+uWZ\nwPd5I3WGeiN+VuP7z64Y9QVOIuTMUyvZtA4/NuiDg0GCBAhaYtMqNWxCoVloMqHp\n7ya7fRba1ZWZRdLIr7/Krq/u\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-5scc0@finalproject-15cde.iam.gserviceaccount.com",
  "client_id": "112552998265671227150",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-5scc0%40finalproject-15cde.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}



cred = credentials.Certificate(firebase_cred)
firebase_admin.initialize_app(cred, {"databaseURL": "https://finalproject-15cde-default-rtdb.europe-west1.firebasedatabase.app/"})
# creating reference to root node
ref = db.reference("/")



model = YOLO("yolov8n.pt")


#to detect the objects
def predict_and_detect(chosen_model, img, conf=0.5):
    img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
   
    results = chosen_model.predict(img, conf=conf)
    print(f"Predict and Detect function output: {type(results)}")  
    return img, results
#to extract the label text
def extract_prediction_text(results):
    for result in results:
        if result.boxes:  
            box = result.boxes[0] 
            prediction_texts = result.names[int(box.cls[0])]
            return prediction_texts 
    return ""  


#to send the label to the RTDB 
def send_to_RTDB(results):
    detection_results = results[1]
    text = str(extract_prediction_text(detection_results))
    db.reference("/INFO").push().set({"label": text})


while True:
    try:
        #to Capture images from the camera URL
        img_resp = urllib.request.urlopen(url)
        imgnp = np.array(bytearray(img_resp.read()), dtype=np.uint8)
        im = cv2.imdecode(imgnp, -1)

        if im is None:
            print("Error: Could not capture image.")
            break

        result_img, detection_results = predict_and_detect(model, im , conf=0.5)

        
        cv2.imshow('Object Detection', result_img)
        send_to_RTDB((result_img, detection_results))

        time.sleep(2)

        if cv2.waitKey(5) & 0xFF == 27:
            break

    except urllib.error.URLError as e:
        print(f"Failed to connect to the camera: {e.reason}")
        break
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        break

cv2.destroyAllWindows()


#include <Wire.h>
#include <EEPROM.h>
#include <Adafruit_TCS34725.h>
#include <LiquidCrystal_I2C.h>
#include <WiFi.h>
#include <FirebaseESP32.h>

const char *ssid = "WIFI";
const char *password = "WIFI_PASSWORD";

#define FIREBASE_HOST "DATABASE_URL"
#define FIREBASE_AUTH "API_KEY"

#define MUX_I2C_ADDRESS 0x70
#define MUX_CHANNEL_LCD 1  // Ganti dengan saluran yang terhubung ke LCD
#define MUX_CHANNEL_TCS 1  // Ganti dengan saluran yang terhubung ke TCS34725

#define USER_EMAIL "EMAIL_SIGNIN";
#define USER_PASSWORD "PASSWORD_SIGNIN";

uint16_t colorTemp;
uint16_t prevColorTemp = 0;

const uint8_t coinPIN = 4;  // Ganti dengan pin yang digunakan untuk input koin

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

String uid;

bool signupOK = false;

LiquidCrystal_I2C lcd(0x27, 16, 2);  // Ganti dengan alamat I2C LCD yang sesuai
Adafruit_TCS34725 tcs;

int i = 0;
int coinsignal = 0;
unsigned long totaluangDetected = 0;
bool tampilcoin = false;
unsigned long rupiah = 0;

void tambahUang(unsigned long nominal);
void tampilkanOutput(unsigned long nominal);
void kirimDataFirebase(unsigned long total);

void IRAM_ATTR tampungsignal() {
  Serial.println("Signal coin terdeteksi!");
  coinsignal++;
  Serial.println("Sinyal dari sensor koin: " + String(coinsignal));
  i = 0;
  tampilcoin = true;
}

void setup() {
  Wire.begin();
  Serial.begin(115200);

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Mengkoneksikan ke WiFi..");
  }
  Serial.println("Terkoneksi ke WiFi");

  Wire.beginTransmission(MUX_I2C_ADDRESS);
  Wire.write(1 << MUX_CHANNEL_LCD);  // Pilih saluran untuk LCD
  Wire.endTransmission();

  Wire.beginTransmission(MUX_I2C_ADDRESS);
  Wire.write(1 << MUX_CHANNEL_TCS);  // Pilih saluran untuk TCS34725
  Wire.endTransmission();

  tcs.begin();  // Inisialisasi sensor warna

  pinMode(coinPIN, INPUT_PULLUP);

  lcd.backlight();
  lcd.setCursor(0, 0);
  lcd.print("Tabungan Tech.");
  lcd.setCursor(0, 1);
  lcd.print("By: Fachri A");
  delay(5000);

  attachInterrupt(digitalPinToInterrupt(coinPIN), tampungsignal, FALLING);
  EEPROM.get(0, totaluangDetected);
  delay(2000);

  config.host = FIREBASE_HOST;
  config.api_key = FIREBASE_AUTH;

  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;
  Firebase.reconnectWiFi(true);
  fbdo.setResponseSize(4096);

//  config.token_status_callback = tokenStatusCallback;

  Firebase.begin(&config, &auth);

  Serial.println("Mendapatkan UID User");
  while (auth.token.uid == "") {
    Serial.print('.');
    delay(1000);
  }
  uid = auth.token.uid.c_str();
  Serial.print("UID User: ");
  Serial.print(uid);

  lcd.clear();
  delay(200);
  lcd.setCursor(0, 0);
  lcd.print(" Masukkan Uang  ");
}

void loop() {
  i++;
  rupiah = totaluangDetected; // Set nilai rupiah sesuai dengan totaluang

  if (Firebase.isTokenExpired()) {
    Firebase.refreshToken(&config);
    Serial.println("Token direfresh!");
  }

  if (totaluangDetected > 0) {
    lcd.setCursor(0, 0);
    lcd.print("Total uang:  ");

    lcd.setCursor(0, 1);
    lcd.print("Rp. ");
    lcd.print(rupiah);
    delay(3000);
  }

  Serial.println("Nilai coin signal: " + String(coinsignal));
  Serial.println("Status tampilcoin: " + String(tampilcoin));

  // Baca warna dari sensor TCS34725
  uint16_t clear, red, green, blue;
  tcs.getRawData(&red, &green, &blue, &clear);

  // Hitung color temperature menggunakan fungsi calculateColorTemperature_dn40()
  colorTemp = tcs.calculateColorTemperature_dn40(red, green, blue, clear);

  // Cetak nilai colorTemp hanya ketika terdapat perubahan warna
  if (colorTemp != prevColorTemp) {
    Serial.println("Color Temperature: " + String(colorTemp));
    prevColorTemp = colorTemp;
  }

  if (colorTemp >= 3296 && colorTemp <= 4100) {
    tambahUang(5000);
  } else if (colorTemp >= 4800 && colorTemp <= 5200) {
    tambahUang(10000);
  } else if (colorTemp >= 5300 && colorTemp <= 5800) {
    tambahUang(20000);
  } else if (colorTemp >= 4800 && colorTemp <= 5202) {
    tambahUang(50000);
  } else if (colorTemp >= 3900 && colorTemp <= 5300) {
    tambahUang(100000);
  } else {
    tampilcoin = false;
  }

  if (coinsignal == 1 && tampilcoin) {
    Serial.println("Masuk Coinsignal 1");
    tambahUang(1000);
    coinsignal = 0;
  }

  if (coinsignal == 2 && !tampilcoin) {
    Serial.println("Masuk coinsignal 2");
    tambahUang(500);
    coinsignal = 0;
  }

  if (digitalRead(coinPIN) == LOW) {
    totaluangDetected = 0;
    coinsignal = 0;
    EEPROM.put(0, totaluangDetected);
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print(" Masukkan Uang  ");
  }

  delay(3000); // Tunggu 3 detik
}

void tambahUang(unsigned long nominal) {
  totaluangDetected += nominal; // Tambahkan nominal ke total uang yang terdeteksi
  tampilkanOutput(nominal);
  kirimDataFirebase(totaluangDetected);
}

void tampilkanOutput(unsigned long nominal) {
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Uang masuk: ");
  lcd.setCursor(0, 1);
  lcd.print("Rp. ");
  lcd.print(nominal);
  Serial.println(nominal);

  delay(2000); // Tahan tampilan selama 2 detik
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Total uang: ");
  lcd.print("Rp. ");
  lcd.print(rupiah);
  Serial.println(rupiah);

  delay(2000); // Tahan tampilan selama 2 detik
  tampilcoin = false;
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print(" Masukkan Uang:  ");
}

void kirimDataFirebase(unsigned long total) {
  String pathTotal = "/tabungan/" + uid + "/total";
  String pathRiwayat = "/tabungan/" + uid + "/riwayat";

  String dataTotal = String(total);
  String dataRiwayat = String(total);

  if (Firebase.setInt(fbdo, pathTotal.c_str(), dataTotal.toInt())) {
    Serial.println("Berhasil mengirim total tabungan ke Server");
  } else {
    Serial.println("Gagal mengirim total tabungan ke Server");
    Serial.println("Error: " + fbdo.errorReason());
    Serial.println("====================");
  }

  if (Firebase.pushInt(fbdo, pathRiwayat.c_str(), dataRiwayat.toInt())) {
    Serial.println("Berhasil mengirim riwayat tabungan ke Server");
  } else {
    Serial.println("Gagal mengirim riwayat tabungan ke Server");
    Serial.println("Error: " + fbdo.errorReason());
    Serial.println("====================");
  }
}
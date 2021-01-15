/*********

  Руи Сантос

  Более подробно о проекте на: http://randomnerdtutorials.com  

*********/


#include <WiFi.h>

#include <ESP32Servo.h>
#include "soc/soc.h" //disable brownout problems
#include "soc/rtc_cntl_reg.h"  //disable brownout problems


Servo myservo1;  // создаем экземпляр класса «Servo»,

                // чтобы с его помощью управлять сервоприводом;

                // большинство плат позволяют

                // создать 12 объектов класса «Servo»

Servo myservo2;
Servo myservo3;
Servo myservo4;
Servo myservo5;

// вставьте здесь учетные данные своей сети:

const char* ssid     = "NETGEAR09";

const char* password = "bluephoenix200";


// создаем веб-сервер на порте «80»:

WiFiServer server(80);


// переменная для хранения HTTP-запроса:

String header;


// несколько переменных для расшифровки значения в HTTP-запросе GET:

String pos = String(5);

String num = String(5);

int pos1 = 0;

int pos2 = 0;

int pos3 = 0;

int ledState = INPUT;             // этой переменной устанавливаем состояние светодиода

long previousMillis = 0;        // храним время последнего переключения светодиода
 
long interval = 1000;           // интервал между включение/выключением светодиода (1 секунда)
 
void setup() {
  WRITE_PERI_REG(RTC_CNTL_BROWN_OUT_REG, 0); //disable brownout detector
  
  Serial.begin(115200);


  // привязываем сервопривод,
  myservo1.attach(12);
  myservo2.attach(13);
  myservo3.attach(14);
  myservo4.attach(15);
  
  // это нажиматели сенсорных кнопок
  pinMode(2, OUTPUT);
  pinMode(4, OUTPUT);  // это еще и светодиод   

  // подключаемся к WiFi при помощи заданных выше SSID и пароля: 

  Serial.print("Connecting to ");  //  "Подключаемся к "

  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {

    delay(500);

    Serial.print(".");

  }

  // печатаем локальный IP-адрес и запускаем веб-сервер:

  Serial.println("");

  Serial.println("WiFi connected.");  //  "WiFi подключен."

  Serial.println("IP address: ");     //  "IP-адрес: "

  Serial.println(WiFi.localIP());

  server.begin();

}


void loop(){

  // здесь будет код, который будет работать постоянно
  // и который не должен останавливаться на время между переключениями свето
  unsigned long currentMillis = millis();
  
  //проверяем не прошел ли нужный интервал, если прошел то
  if(currentMillis - previousMillis > interval) {
    // сохраняем время последнего переключения
    previousMillis = currentMillis; 
 
    // если светодиод не горит, то зажигаем, и наоборот
    if (ledState == OUTPUT)
      ledState = INPUT;
    else
      ledState = OUTPUT;
 
    // устанавливаем состояния выхода, чтобы включить или выключить светодиод
    pinMode(4,ledState);
    //digitalWrite(4, ledState);
  }
  
  // начинаем прослушивать входящих клиентов:

  WiFiClient client = server.available();


  if (client) {                     // если подключился новый клиент,     

    Serial.println("New Client.");  // печатаем сообщение

                                    // «Новый клиент.»

                                    // в мониторе порта;

    String currentLine = "";        // создаем строку для хранения

                                    // входящих данных от клиента;

    while (client.connected()) {    // цикл while() будет работать

                                    // все то время, пока клиент

                                    // будет подключен к серверу;

      if (client.available()) {     // если у клиента есть данные,

                                    // которые можно прочесть, 

        char c = client.read();     // считываем байт, а затем    

        Serial.write(c);            // печатаем его в мониторе порта

        header += c;

        if (c == '\n') {            // если этим байтом является

                                    // символ новой строки

          // если получили два символа новой строки подряд,

          // то это значит, что текущая строчка пуста;

          // это конец HTTP-запроса клиента,

          // а значит – пора отправлять ответ:

          if (currentLine.length() == 0) {

            // HTTP-заголовки всегда начинаются

            // с кода ответа (например, «HTTP/1.1 200 OK»)

            // и информации о типе контента

            // (чтобы клиент понимал, что получает);

            // в конце пишем пустую строчку:

            client.println("HTTP/1.1 200 OK");

            client.println("Content-type:text/html");

            client.println("Connection: close");

                       //  "Соединение: отключено"

            client.println();


            // показываем веб-страницу:

            client.println("<!DOCTYPE html><html>");

            client.println("<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">");

            client.println("<link rel=\"icon\" href=\"data:,\">");

            client.println("<style>body { text-align: center; font-family: \"Trebuchet MS\", Arial; margin-left:auto; margin-right:auto;}");

            client.println(".slider { width: 300px; }</style>");

            client.println("<script src=\"https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js\"></script>");

                     

            // веб-страница:

            client.println("</head><body><h1>Buttons</h1>");

            client.println("<input type=\"button\" id= \"button_1_press\" value=\"Button 1 PRESS\" onClick=servo(1,90)> <input type=\"button\" id= \"button_1_release\" value=\"Button 1 RELEASE\" onClick=servo(1,0)> </br>" );

            client.println("<input type=\"button\" id= \"button_2_press\" value=\"Button 2 PRESS\" onClick=servo(2,90)> <input type=\"button\" id= \"button_2_release\" value=\"Button 2 RELEASE\" onClick=servo(2,0)> </br>" );

            client.println("<input type=\"button\" id= \"button_3_press\" value=\"Button 3 PRESS\" onClick=servo(3,90)> <input type=\"button\" id= \"button_3_release\" value=\"Button 3 RELEASE\" onClick=servo(3,0)> </br>" );

            client.println("<input type=\"button\" id= \"button_4_press\" value=\"Button 4 PRESS\" onClick=servo(4,90)> <input type=\"button\" id= \"button_4_release\" value=\"Button 4 RELEASE\" onClick=servo(4,0)> </br>" );
            
            client.println("<input type=\"button\" id= \"button_5_press\" value=\"Button 5 PRESS\" onClick=servo(5,90)> <input type=\"button\" id= \"button_5_release\" value=\"Button 5 RELEASE\" onClick=servo(5,0)> </br>" );
            
            client.println("<input type=\"button\" id= \"button_10_press\" value=\"Button 10 PRESS\" onClick=servo(10,90)> <input type=\"button\" id= \"button_10_release\" value=\"Button 10 RELEASE\" onClick=servo(10,0)> </br>" );            
            
            client.println("<script>$.ajaxSetup({timeout:1000}); function servo(num, pos) { ");

            client.println("$.get(\"/?num=\" + num + \"|pos=\" + pos + \"&\"); {Connection: close};}</script>");

           

            client.println("</body></html>");     

            

            //GET /?value=180& HTTP/1.1

            if(header.indexOf("GET /?num=")>=0) {

              pos1 = header.indexOf("num=");

              pos2 = header.indexOf("pos=");

              pos3 = header.indexOf('&');

              num = header.substring(pos1+4, pos2-1);

              pos = header.substring(pos2+4, pos3);

              

              // вращаем ось сервомотора:

              if(num=="1") {myservo1.write(pos.toInt());}
              if(num=="2") {myservo2.write(pos.toInt());}
              if(num=="3") {myservo3.write(pos.toInt());}
              if(num=="4") {myservo4.write(pos.toInt());}
              if(num=="5") {myservo5.write(pos.toInt());}
              if(num=="10" and pos=="90") {pinMode(2,INPUT);}
              if(num=="10" and pos=="0") {pinMode(2,OUTPUT);}

              Serial.println(num + "|" + pos); 

            }         

            // конец HTTP-ответа задается 

            // с помощью дополнительной пустой строки:

            client.println();

            // выходим из цикла while(): 

            break;

          } else { // если получили символ новой строки,

                   // очищаем текущую строку «currentLine»:

            currentLine = "";

          }

        } else if (c != '\r') {  // если получили любые данные,

                                 // кроме символа возврата каретки,

          currentLine += c;      // добавляем эти данные 

                                 // в конец строки «currentLine»

        }

      }

    }

    // очищаем переменную «header»:

    header = "";

    // отключаем соединение:

    client.stop();

    Serial.println("Client disconnected.");

               //  "Клиент отключился."

    Serial.println("");

  }

}

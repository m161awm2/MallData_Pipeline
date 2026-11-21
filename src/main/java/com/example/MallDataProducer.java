package com.example;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringSerializer;

import java.util.Properties;

public class MallDataProducer {
    public static void main(String[] args) {
        // 1. 설정
        Properties props = new Properties();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "localhost:9092");
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());

        // 2. 프로듀서 생성
        KafkaProducer<String, String> producer = new KafkaProducer<>(props);

        // 3. 보낼 메시지(레코드) 생성
        ProducerRecord<String, String> record =
                new ProducerRecord<>("test-topic", "hello kafka");

        // 4. 전송
        producer.send(record);

        // 5. 버퍼에 남은 거 다 보내고 종료
        producer.flush();
        producer.close();
    }
}
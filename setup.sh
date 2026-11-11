#!/usr/bin/env bash
# 개발 환경 기본 세팅: Java/Maven 확인, Kafka 브로커 확인, 토픽 생성, 컴파일
set -euo pipefail

KAFKA_HOME="${KAFKA_HOME:-$HOME/kafka_2.13-4.2.2}"
BOOTSTRAP_SERVER="${BOOTSTRAP_SERVER:-localhost:9092}"
TOPIC="${TOPIC:-test-topic}"

echo "[1/4] Java 확인"
if ! command -v java >/dev/null 2>&1; then
  echo "Java가 없습니다. JDK 17 이상을 설치하세요." >&2
  exit 1
fi
java -version 2>&1 | head -1

echo "[2/4] Maven 확인"
if ! command -v mvn >/dev/null 2>&1; then
  if command -v brew >/dev/null 2>&1; then
    echo "Maven이 없어 Homebrew로 설치합니다."
    brew install maven
  else
    echo "Maven이 없습니다. Maven을 설치하세요." >&2
    exit 1
  fi
fi
mvn -v | head -1

echo "[3/4] Kafka 브로커 확인 및 토픽 생성 ($BOOTSTRAP_SERVER)"
if [ ! -x "$KAFKA_HOME/bin/kafka-topics.sh" ]; then
  echo "KAFKA_HOME($KAFKA_HOME)에서 Kafka를 찾을 수 없습니다. KAFKA_HOME을 지정하세요." >&2
  exit 1
fi
if ! "$KAFKA_HOME/bin/kafka-topics.sh" --bootstrap-server "$BOOTSTRAP_SERVER" --list >/dev/null 2>&1; then
  echo "브로커에 연결할 수 없습니다. 먼저 Kafka를 실행하세요:" >&2
  echo "  $KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties" >&2
  exit 1
fi
"$KAFKA_HOME/bin/kafka-topics.sh" --bootstrap-server "$BOOTSTRAP_SERVER" \
  --create --if-not-exists --topic "$TOPIC" --partitions 1 --replication-factor 1

echo "[4/4] 프로젝트 컴파일"
mvn -q compile

echo "세팅 완료. 실행: mvn -q exec:java -Dexec.mainClass=com.example.Producer"

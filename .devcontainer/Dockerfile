ARG DOCKER_TAG=latest
FROM espressif/idf:${DOCKER_TAG}

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update -y && apt-get install -y udev

# Копируем файл правил udev в контейнер
# только для LINUX
# COPY rules/50-myusb.rules /etc/udev/rules.d/50-myusb.rules
# COPY rules/99-esp32.rules /etc/udev/rules.d/99-espressif.rules

RUN echo "source /opt/esp/idf/export.sh > /dev/null 2>&1" >> ~/.bashrc

ENTRYPOINT [ "/opt/esp/entrypoint.sh" ]

CMD ["/bin/bash", "-c"]

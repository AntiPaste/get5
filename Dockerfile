FROM    ubuntu:xenial

ENV     SMVERSION=1.9
ENV     SMPACKAGE="http://sourcemod.net/latest.php?os=linux&version=${SMVERSION}"
ENV     PATH="${PATH}:/src/addons/sourcemod/scripting"

WORKDIR /src

RUN     apt-get update && \
        apt-get install -y lib32stdc++6 build-essential git wget python-pip

RUN     wget -q -O /opt/sourcemod.tar.gz "$SMPACKAGE" && \
        wget -q -O /opt/SteamWorks.inc https://raw.githubusercontent.com/KyleSanderson/SteamWorks/master/Pawn/includes/SteamWorks.inc && \
        git clone https://github.com/splewis/sm-builder && \
        cd sm-builder && \
        pip install -r requirements.txt && \
        python setup.py install && \
        cd ..

COPY    . .

RUN     tar -zxf /opt/sourcemod.tar.gz && \
        cp /opt/SteamWorks.inc addons/sourcemod/scripting/include/ && \
        cp -r ./dependencies/sm-json/addons/sourcemod/scripting/include/* ./addons/sourcemod/scripting/include && \
        smbuilder --flags="-E"

CMD     [""]

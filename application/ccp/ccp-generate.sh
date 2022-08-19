#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${MSP}/$6/" \
        -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ${DIR}/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${MSP}/$6/" \
        -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ${DIR}/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

# Where am I?
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

NET_DIR_PATH="${DIR}/../../network"

ORG=org1
P0PORT=7051
CAPORT=7054
PEERPEM=${NET_DIR_PATH}/organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem
CAPEM=${NET_DIR_PATH}/organizations/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem
MSP=Org1

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ${DIR}/connection-org1.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ${DIR}/connection-org1.yaml

ORG=org2
P0PORT=9051
CAPORT=8054
PEERPEM=${NET_DIR_PATH}/organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem
CAPEM=${NET_DIR_PATH}/organizations/peerOrganizations/org2.example.com/ca/ca.org2.example.com-cert.pem
MSP=Org2

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ${DIR}/connection-org2.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ${DIR}/connection-org2.yaml

ORG=userorg
P0PORT=11051
CAPORT=9054
PEERPEM=${NET_DIR_PATH}/organizations/peerOrganizations/userorg.example.com/tlsca/tlsca.userorg.example.com-cert.pem
CAPEM=${NET_DIR_PATH}/organizations/peerOrganizations/userorg.example.com/ca/ca.userorg.example.com-cert.pem
MSP=UserOrg

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ${DIR}/connection-userorg.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ${DIR}/connection-userorg.yaml

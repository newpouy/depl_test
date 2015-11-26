#!/bin/bash

# 다음의 전제 하에 작성된 스크립트입니다.
# 1. 톰캣의 webapps폴더에 war를 배포하고 압축을 푼다. 
# 2. 톰캣의 webapps폴더에 이 쉘스크립트가 위치한다. 
# 3. 현재 배포버전을 가리키는 심볼릭링크명은 'link'이다.

echo "depl_test"

CHECK=`ps -ef | grep tomcat | grep -v grep | wc -l` #톰캣프로세스 갯수 체크
DATE=`date +%Y%m%d%H%M%S` #현재시간 받아오기
echo $CHECK
echo $DATE

# 톰캣 구동 확인 
if [ $CHECK -ge 1 ];
then
	echo "tomcat is running"
else
	echo "tomcat isn't running"	
fi

i=0; #디렉토리 갯수를 카운트하기 위한 변수
for directory in `ls -d *`; do #현재 경로의 모든 디렉토리를 순환하면서 
	INITString=`expr "${directory:0:7}"` #디렉토리의0~7문자열
	case $INITString in
		"deploy_")  # 문자열이 deploy로 시작할 경우
			depl_arr[i]=$directory # 배열에 넣는다 
			echo $i $directory
			let i=i+1
			
	esac
done
arr_length=${#depl_arr[@]} # 배열길이 저장
echo Array Length is $arr_length #배열길이 출력 
LASTVersion=${depl_arr[$arr_length-1]} #가장 최근 배포 폴더를 저장한다
echo LASTVersion: $LASTVersion

WAR=$PWD/depl_test.war # war절대경로 저장
NOWVersion=deploy_$DATE # 최신배포 디렉토리명 저장
mkdir $NOWVersion # 최신 배포 디렉토리 만들기
echo NOWVersion:  $NOWVersion
cd $NOWVersion #최신 배포 디렉토리로 이동
jar xvf $WAR #압축풀기

cd .. # 상위폴더로 이동
ln -nfs $NOWVersion link # 최신 배포 버전으로 link심볼릭링크 taget변경

#이하 톰캣 재구동 스크립트 작성 필요.
if [ $CHECK -ge 1 ];
then
	echo "tomcat is running"
else
	echo "tomcat isn't running"	
fi



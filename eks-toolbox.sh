#!/usr/bin/env bash
#Author: zuoguocai@126.com
# Description: toolbox for eks

#====================参数区 begin ====================
A=`tput blink`
B=`tput sgr0`
week_num=`date +%w`
week_array=(日 一 二 三 四 五 六)
WEEK=${week_array[$week_num]}
DATE=`date +%F`
#====================参数区 end ====================


#====================eks begin ====================

function Get-Cluster(){
	kubectl cluster-info
	kubectl get  nodes  
	kubectl api-resources --namespaced=true  -o wide
        kubectl config view
}


function Get-TCR(){
	kubectl get secrets
}

function Get-Deploy(){
        kubectl get namespace
        kubectl get configmap  --all-namespaces
        kubectl get pvc    --all-namespaces
	kubectl get  pods  --all-namespaces
	kubectl get  deployments --all-namespaces
	kubectl get  svc   --all-namespaces
	kubectl get  ingress --all-namespaces 
}


function Diag-Error(){
        pod_name=${1}
        ns_name=${2}
	kubectl describe nodes
	kubectl describe pod ${pod_name}  -n ${ns_name}
	kubectl logs -f  ${pod_name}
	kubectl exec -it   ${pod_name}  /bin/bash  -n ${ns_name}
	kubectl exec -it   ${pod_name}  /bin/sh  -n ${ns_name}
	kubectl exec -it   ${pod_name}  cmd.exe  -n ${ns_name}
}

function Deply-App(){
        yaml_name=${1}
        ns_name=${2}
	kubectl apply -f   ${yaml_name}   -n ${ns_name}
}

function Cheat-Sheet(){
	cat <<-__EOF__
	kubectl  备忘单
	请参考: https://kubernetes.io/zh/docs/reference/kubectl/cheatsheet/
	__EOF__
}
#====================eks end ====================









#==================== menu begin =========================
menu(){
clear
cat <<-EOF
*************************************************************************
*                                                                       *
*    $A                    【 Tencent Cloud EKS 运维工具  】             $B *
*                                                                       *
*        1.   查询集群状态                                              *
*        2.   查询下发的TCR Key                                         *
*        3.   查询部署情况                                              *
*        4.   诊断错误                                                  *
*        5.   简单部署                                                  *
*        6.   备忘清单                                                  *
*        h.   获得上仙的帮助                                            *
*        q.   给朕退下                                                  *
*                                                                       *
*                                                                       *
*                                                                       *
*              今天是$DATE                 周$WEEK                    *
*                                                                       *
*                                                                       *
*************************************************************************
EOF
}
#====================== menu end ============================


#=======================prompt begin ========================
while true
do
	menu
	read -p  "请选择OPS(5s后自动进入重新选择):"  choice
	case ${choice} in
	1)
		echo "查询集群状态..."
		Get-Cluster
		echo ""
	;;
	2)
		echo "查询Secret..."
		Get-TCR
		echo ""
	;;
	3)
		echo "查询部署情况..."
		Get-Deploy
		echo ""
	;;


	4)
		echo "开始诊断..."
                read -p  "请输入pod name:"  pod_name
                read -p  "请输入namespace:"  ns_name
                Diag-Error "${pod_name}"  "${ns_name}"
		echo ""
	;;
	5)
		echo "开始部署..."
                read -p  "请输入yaml文件名:"  yaml_name
                read -p  "请输入namespace:"  ns_name
                Deply-App  "${yaml_name}"  "${ns_name}"
		echo ""
	;;
	6)
		echo ""
		Cheat-Sheet
	;;

	q|quit|exit)
 		exit
	;;

	h)
	cat <<-__EOF__

		1. 请阅读后使用
		2. 如果选择框，输入其他文字，可以用 ctrl+backup 退格，重新输入

	__EOF__

	;;

	*)
		 echo "^_^ 您仿佛来到没有知识的荒原..."
	;;
	esac
        sleep 5
done
#=======================prompt end =======================

#!/bin/bash
alias k=kubectl
source <(kubectl completion bash)
complete -F __start_kubectl k

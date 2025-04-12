# iac-testenv-construction
VirtualBox,Vagrant,Terraform,Ansible,AWXの環境構築、動作確認など検証用

IaC練習プロジェクトの目的は、Ansible、Docker、Terraform、Chef などによる**複数環境の自動構築と連携**

以下を加味した**発展的で整理されたディレクトリ構成**を記載

- マルチVM管理（Vagrant + Terraform）
- マルチ構成管理（Ansible, Chef）
- コンテナ環境（Docker, Kubernetes, Helm）
- イメージ作成（Packer）
- CI/CDツール連携（GitHub Actions, Drone CI）

---

## 📁 最終提案：IaC練習プロジェクトの統合ディレクトリ構成

```
iac_lab/
├── environments/                # 仮想環境（VM）単位でまとめる
│   ├── base_vm/                # 接続確認など最小構成用
│   ├── awx_vm/                 # AWX/K8s用のVM環境
│   └── docker_host/            # Docker中心の環境構築用
│
├── terraform/                  # Terraform定義。環境ごとに分割
│   ├── base_vm/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfstate
│   ├── awx_vm/
│   │   ├── main.tf
│   │   └── variables.tf
│   └── shared/                 # 共通モジュールなど（任意）
│       └── network.tf
│
├── vagrant/                    # VMの起動スクリプト（Vagrantfile）
│   ├── base_vm/Vagrantfile
│   └── awx_vm/Vagrantfile
│
├── ansible/                    # Ansibleによる構成管理
│   ├── inventories/
│   │   ├── base_vm.ini
│   │   └── awx_vm.ini
│   ├── playbooks/
│   │   ├── setup_base.yml
│   │   └── deploy_awx.yml
│   └── roles/
│       ├── apache/
│       └── docker/
│
├── chef/                       # Chef SoloまたはZeroで構成管理
│   ├── cookbooks/
│   │   └── apache/
│   └── environments/
│       └── base_vm.json
│
├── docker/                     # Docker関連のテスト環境
│   ├── nginx_server/
│   │   ├── Dockerfile
│   │   └── docker-compose.yml
│   └── awx_test/
│       └── compose.yml
│
├── kubernetes/                 # K8s関連（Helm、manifest）
│   ├── manifests/
│   │   └── awx.yaml
│   ├── helm/
│   │   └── awx-chart/
│   └── minikube_setup.sh
│
├── packer/                     # VMやAMIの自動イメージ作成
│   ├── ubuntu2204.json
│   └── scripts/
│       └── install_docker.sh
│
├── ci_cd/                      # CI/CD構成（GitHub Actions, Droneなど）
│   ├── github/
│   │   └── workflows/
│   │       └── terraform_plan.yml
│   └── drone/
│       └── .drone.yml
│
├── scripts/                    # 共通で使うスクリプト（手動セットアップなど）
│   ├── install_common_tools.sh
│   └── setup_k8s.sh
│
└── README.md                   # 概要・使い方・構築手順などを記載

```

---

## 📌 各ディレクトリの補足と注意点

| ディレクトリ | 説明・注意点 |
|--------------|-------------|
| `environments/` | 複数VMを管理。環境単位でまとめることでTerraform・Vagrant・Ansibleから一貫管理しやすくなります。 |
| `vagrant/` | VM作成専用。再利用性・バージョン管理に便利。Vagrantfileは環境ごとに分けるとよい。 |
| `terraform/` | null_resourceやremote-exec、将来的にはcloud providerへの移行も考慮。構成変更に強い。 |
| `ansible/` | playbook/roles/inventories構成で標準的。VMやDocker両方に展開できる設計を目指す。 |
| `chef/` | Chef solo向け。今後knifeやChef Serverも学ぶなら構成変更の余地あり。 |
| `docker/` | 各種構築環境をDockerで試す場。サービス単位や環境単位で分けると整理しやすい。 |
| `kubernetes/` | minikube/helm/kustomizeを管理。manifestを直接書くパターンとHelm併用も想定。 |
| `packer/` | VMやAWS AMIイメージを自動生成。CIと連携することで実戦的になる。 |
| `ci_cd/` | GitHub ActionsやDroneなど。Terraform Planの自動化やAnsible Playbookの実行連携も可能。 |
| `scripts/` | 共通で使い回す処理（apt installなど）をまとめ、DRY原則を維持。 |

---

## ✅ この構成のメリット

- **目的別 + ツール別の明確な分離**で保守・追加がしやすい
- **ツール横断で同じVMや環境に構成を当てられる**
- **拡張性が高く、CI/CD・Cloud連携にもつなげやすい**

---

必要ならこの構成で`README.md`テンプレートや、`base_vm`のVagrantfile雛形もご提供できます。  
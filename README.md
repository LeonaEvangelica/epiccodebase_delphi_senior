
# 📘 Projeto: epiccodebase_delphi_senior

Sistema de Gestão de Ordens de Serviço (OS) desenvolvido em Delphi com arquitetura em camadas, integração com SQL Server, consumo da API ViaCEP e aplicação de princípios SOLID.

---

## 🚀 Passos para Executar o Projeto

### ✅ Requisitos
- **Delphi / RAD Studio 12 (Athens)** ou superior
- **SQL Server 2022**
- **FireDAC** configurado para conectar ao SQL Server
- **Internet ativa** (para consumo da API ViaCEP)
- **Componentes padrão da VCL** (nenhuma dependência externa)

### 🔧 Configuração do Banco de Dados

1. Execute o script SQL localizado em `/database/criar_banco.sql` para criar as tabelas necessárias.
2. Configure a conexão do FireDAC (`TFDConnection`) com os parâmetros do seu ambiente local.

Exemplo de connection string:
```
Server=localhost;Database=GestaoOS;Trusted_Connection=True;
```

---

## 📁 Estrutura de Pastas

```
epiccodebase_delphi_senior/
│
├── /src/
│   ├── /Model/              → Entidades de domínio (TOrdemServico, TOrdemServicoItem)
│   ├── /DTO/                → Objetos de transferência (TOrdemServicoDTO, TOrdemServicoItemDTO)
│   ├── /Interfaces/         → Interfaces de repositórios (IOrdemServicoRepository)
│   ├── /Repository/         → Implementação de acesso a dados com FireDAC (SQL Server)
│   ├── /Service/            → Lógica de negócio, validações e regras de status
│   ├── /ViewModel/          → Intermediário entre View e Service, conversões entre DTO/Model
│   ├── /View/               → Formulários (VCL)
│   └── /Utils/              → Serviços auxiliares (ex: integração ViaCEP)
│
├── /database/
│   └── criar_banco.sql      → Script para criação das tabelas no SQL Server
│
├── /tests/
│   └── TestOrdemServico.pas → Testes unitários com DUnitX
│
└── README.md                → Este arquivo
```

---

## 📐 Arquitetura

O projeto adota uma arquitetura em camadas baseada nos princípios SOLID, com separação clara de responsabilidades:

- **Model**: Entidades de domínio puro
- **DTO**: Estruturas de dados simplificadas para comunicação com a View
- **Interfaces**: Contratos para acesso a dados
- **Repository**: Implementações de acesso ao SQL Server
- **Service**: Lógica de negócio (validação, finalização, cancelamento, cálculo)
- **ViewModel**: Interação entre a UI e o domínio, isolando regras e dados
- **View (VCL Form)**: Interface do usuário desacoplada da lógica

---

## 🌐 Funcionalidades Incluídas

- Cadastro de Ordem de Serviço
- Cadastro de itens utilizados (peças)
- Cálculo automático do valor total da OS
- Finalização com validações obrigatórias
- Cancelamento com justificativa
- Exportação futura para CSV
- Consulta de endereço por CEP via API do ViaCEP
- Cobertura de testes unitários das regras principais

---

## 🧪 Testes Unitários

Utilizando **DUnitX**. Localizados na pasta `/tests`.

Execute os testes pelo DUnitX Test Runner ou integre à sua automação de build.

---

## ✨ Autor

Desenvolvido como parte do desafio técnico da [Epic Codebase](https://epiccodebase.com).

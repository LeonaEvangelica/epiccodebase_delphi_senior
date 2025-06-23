-- Banco de dados (caso queira criar um novo)
CREATE DATABASE GestaoOS;
GO

USE GestaoOS;
GO

-- Tabela principal: Ordem de Serviço
CREATE TABLE OrdemServico (
    Numero INT IDENTITY(1,1) PRIMARY KEY,
    DataAbertura DATETIME NOT NULL DEFAULT GETDATE(),
    DataConclusao DATETIME NULL,
    ClienteNome NVARCHAR(100) NOT NULL,
    ClienteDocumento NVARCHAR(20) NOT NULL,
    CEP NVARCHAR(10),
    Logradouro NVARCHAR(100),
    Bairro NVARCHAR(100),
    Cidade NVARCHAR(100),
    UF NVARCHAR(2),
    TecnicoResponsavel NVARCHAR(100),
    DescricaoProblema NVARCHAR(MAX),
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('Aberta', 'Em Andamento', 'Finalizada', 'Cancelada')),
    JustificativaCancelamento NVARCHAR(MAX) NULL,
    HorasTrabalhadas DECIMAL(10,2) DEFAULT 0
);
GO

-- Tabela de Itens da OS
CREATE TABLE OrdemServicoItem (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    NumeroOS INT NOT NULL, -- FK para OrdemServico.Numero
    NumeroItem INT NOT NULL, -- Sequencial por OS (preenchido pela aplicação)
    NomePeca NVARCHAR(100) NOT NULL,
    Quantidade INT NOT NULL CHECK (Quantidade > 0),
    ValorUnitario DECIMAL(10,2) NOT NULL CHECK (ValorUnitario >= 0),

    CONSTRAINT FK_OrdemServicoItem_OrdemServico
        FOREIGN KEY (NumeroOS) REFERENCES OrdemServico(Numero)
        ON DELETE CASCADE
);
GO

-- Índice auxiliar (busca rápida por cliente ou status)
CREATE INDEX IDX_OrdemServico_Cliente_Status
    ON OrdemServico (ClienteNome, Status);
GO

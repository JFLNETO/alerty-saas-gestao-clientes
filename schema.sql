-- =============================================================
-- Schema: alerty
-- Banco de dados: PostgreSQL (Supabase)
-- Descrição: Sistema SaaS de gestão de mensalidades e
--            notificações automáticas via WhatsApp
-- =============================================================

CREATE SCHEMA IF NOT EXISTS alerty;

-- -------------------------------------------------------------
-- Tabela: alertas
-- Armazena as configurações de alertas por empresa,
-- incluindo tipo, mensagem e selo correspondente ao status.
-- -------------------------------------------------------------
CREATE TABLE alerty.alertas (
  id_unico             INTEGER      NOT NULL DEFAULT nextval('alerty.alertas_id_unico_seq'),
  tipo                 TEXT,
  dias                 INTEGER,
  selo_correspondente  INTEGER,
  mensagam             TEXT,
  id_empresa           INTEGER,
  PRIMARY KEY (id_unico)
);

-- -------------------------------------------------------------
-- Tabela: clientes
-- Cadastro completo de alunos/clientes por empresa.
-- id_cliente é gerado no formato {empresa}_{telefone}@s.whatsapp.net
-- para integração direta com a API de WhatsApp.
-- selos e id_servicos são arrays para suporte a multi-modalidades.
-- -------------------------------------------------------------
CREATE TABLE alerty.clientes (
  id_unico               INTEGER  NOT NULL DEFAULT nextval('alerty.clientes_id_unico_seq'),
  nome                   TEXT,
  id_cliente             TEXT,
  ativo                  BOOLEAN,
  data_vencimento        DATE,
  data_ultimo_pagamento  DATE,
  id_servicos            INTEGER[],
  selos                  INTEGER[],
  id_empresa             INTEGER,
  telefone               TEXT,
  url_foto               TEXT,
  PRIMARY KEY (id_unico)
);

-- -------------------------------------------------------------
-- Tabela: config_empresa
-- Configurações gerais de cada empresa cadastrada no SaaS.
-- Armazena dados do dono, logo, limites e controle de vencimento
-- da assinatura da empresa no sistema.
-- -------------------------------------------------------------
CREATE TABLE alerty.config_empresa (
  id_unico              INTEGER                      NOT NULL DEFAULT nextval('alerty.config_empresa_id_unico_seq'),
  data_vencimento       TIMESTAMP WITHOUT TIME ZONE,
  nome                  TEXT,
  selos                 INTEGER[],
  limite_notificacoes   INTEGER,
  whatsapp_dono         TEXT,
  nome_dono             TEXT,
  created_date          TIMESTAMP WITHOUT TIME ZONE,
  modified_date         TIMESTAMP WITHOUT TIME ZONE,
  link_logo             TEXT,
  id_empresa            INTEGER,
  PRIMARY KEY (id_unico)
);

-- -------------------------------------------------------------
-- Tabela: historico_cobranca
-- Registro imutável de cada pagamento confirmado.
-- Mantém rastreabilidade financeira por cliente e empresa,
-- com data do pagamento e vencimento anterior como referência.
-- -------------------------------------------------------------
CREATE TABLE alerty.historico_cobranca (
  id_unico          INTEGER                      NOT NULL DEFAULT nextval('alerty.historico_cobranca_id_unico_seq'),
  id_cliente        TEXT,
  id_empresa        INTEGER,
  data_pagamento    DATE,
  data_vencimento   DATE,
  created_date      TIMESTAMP WITHOUT TIME ZONE,
  valor             NUMERIC,
  PRIMARY KEY (id_unico)
);

-- -------------------------------------------------------------
-- Tabela: servicos
-- Modalidades/serviços oferecidos por cada empresa.
-- Suporta recorrência configurável (ex: mensal, trimestral).
-- Referenciado por clientes via array id_servicos.
-- -------------------------------------------------------------
CREATE TABLE alerty.servicos (
  id_unico           INTEGER                      NOT NULL DEFAULT nextval('alerty.servicos_id_unico_seq'),
  nome               TEXT,
  id_empresa         INTEGER,
  valor              NUMERIC,
  recorrencia_valor  INTEGER,
  recorrencia_tipo   TEXT,
  created_date       TIMESTAMP WITHOUT TIME ZONE,
  modified_date      TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (id_unico)
);

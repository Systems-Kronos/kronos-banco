-- =====================================================================
-- ARQUIVO DE ALTERAÇÕES MANUAIS (Quando DROPSCHEMA=False)
-- =====================================================================
--
-- IMPORTANTE:
--
-- 1. Adicione seus scripts SQL (ALTER TABLE, CREATE INDEX, etc.)
--    ABAIXO deste bloco de comentários.
--
-- 2. AO CRIAR UM NOVO PULL REQUEST (PR) PARA FAZER UMA ALTERAÇÃO,
--    CERTIFIQUE-SE DE APAGAR QUALQUER SQL ANTIGO QUE ESTEJA AQUI.
--
-- 3. O pipeline (que roda na 'main') irá executar o que estiver
--    aqui e NÃO irá limpar o arquivo. A limpeza é manual.
--
-- =====================================================================

-- EXEMPLO DE COMO ADICIONAR UM SCRIPT:
--
-- ALTER TABLE public.Usuario ADD COLUMN cNovaColuna VARCHAR(50) NULL;
-- CREATE INDEX idx_usuario_email ON public.Usuario(cEmail);
--

--[BD][Usuario]
ALTER TABLE usuario
      ALTER COLUMN csenha SET DEFAULT 'Senha@123';
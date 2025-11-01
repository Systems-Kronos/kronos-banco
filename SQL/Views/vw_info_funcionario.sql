DROP VIEW IF EXISTS vw_info_funcionario;

CREATE OR REPLACE VIEW vw_info_funcionario
AS
    WITH HabilidadesPorUsuario AS (
        SELECT hu.nCdUsuario
             , STRING_AGG(h.nCdHabilidade::TEXT, ', ') AS cCdHabilidades
             , STRING_AGG(h.cNmHabilidade, ', ')       AS cNmHabilidades
          FROM public.HabilidadeUsuario hu
               INNER JOIN public.Habilidade h ON hu.nCdHabilidade = h.nCdHabilidade
         GROUP BY hu.nCdUsuario
    )
        SELECT u.nCdUsuario
             , u.cNmUsuario
             , u.nCdEmpresa
             , e.cNmEmpresa
             , u.nCDSetor
             , s.cNmSetor
             , u.nCdGestor
             , u.bGestor
             , u.nCdCargo
             , c.cNmCargo
             , hu.cCdHabilidades
             , hu.cNmHabilidades
             , u.cCPF
             , u.cTelefone
             , u.cEmail
             , u.cFoto
             , u.bAtivo
          FROM Usuario u
               INNER JOIN public.Empresa           e  ON u.nCdEmpresa = e.nCdEmpresa
               INNER JOIN public.Setor             s  ON u.nCdSetor   = s.nCdSetor
               INNER JOIN public.Cargo             c  ON c.nCdCargo   = u.nCdCargo
                LEFT JOIN HabilidadesPorUsuario    hu    ON hu.nCdUsuario = u.nCdUsuario;
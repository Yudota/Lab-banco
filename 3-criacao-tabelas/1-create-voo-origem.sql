-- Verificando as diferentes formas de um voo origem no tabelao
select distinct AERONAVE_VOO_ORIGEM from tabelao;

-- Criando sequence e trigger para mapear os ids
create sequence sq_voo_origem nocache;
create trigger tg_sq_voo_origem before insert on voo_origem for each row
begin
    :new.ori_id := sq_voo_origem.nextval;
end;

-- Inserindo no voo origem os campos, já com a sequence e o trigger funcionando
insert into voo_origem(ori_local_voo_origem)(
    select distinct AERONAVE_VOO_ORIGEM from tabelao
);

-- Apenas upando o tabelão com novos valores e testando consultas
update tabelao set 
    AERONAVE_VOO_ORIGEM = (select voo_origem.ori_id from voo_origem where voo_origem.ori_local_voo_origem = tabelao.aeronave_voo_origem);

select * from tabelao;


-- Para verificar se a sequence foi usada

SELECT sq_voo_origem.currval from dual;

select * from voo_origem where ori_id = 730;
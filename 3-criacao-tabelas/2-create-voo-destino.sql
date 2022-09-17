-- Verificando as diferentes formas de um voo origem no tabelao
select distinct AERONAVE_VOO_DESTINO from tabelao;

-- Criando sequence e trigger para mapear os ids
create sequence sq_voo_destino nocache;
create trigger tg_sq_voo_destino before insert on voo_destino for each row
begin
    :new.des_id := sq_voo_destino.nextval;
end;

-- Inserindo no voo origem os campos, já com a sequence e o trigger funcionando
insert into voo_destino(des_local_voo_destino)(
    select distinct AERONAVE_VOO_DESTINO from tabelao
);

-- Apenas upando o tabelão com novos valores e testando consultas
update tabelao set 
    AERONAVE_VOO_DESTINO = (select voo_destino.des_id from voo_destino where voo_destino.des_local_voo_destino = tabelao.aeronave_voo_destino);

select * from tabelao;


-- Para verificar se a sequence foi usada

SELECT sq_voo_destino.currval from dual;

select * from voo_destino where des_id = 727;
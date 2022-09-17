-- Verificando as diferentes formas de um voo origem no tabelao
select distinct AERONAVE_NIVEL_DANO from tabelao;

-- Criando sequence e trigger para mapear os ids
create sequence sq_nivel_dano nocache;
create trigger tg_sq_nivel_dano before insert on nivel_dano for each row
begin
    :new.dan_id := sq_nivel_dano.nextval;
end;

-- Inserindo no voo origem os campos, já com a sequence e o trigger funcionando
insert into nivel_dano(dan_nivel_dano)(
    select distinct AERONAVE_NIVEL_DANO from tabelao
);

-- Apenas upando o tabelão com novos valores e testando consultas
update tabelao set 
    AERONAVE_NIVEL_DANO = (select nivel_dano.dan_id from nivel_dano where nivel_dano.dan_nivel_dano = tabelao.AERONAVE_NIVEL_DANO);

select * from tabelao;


-- Para verificar se a sequence foi usada

SELECT sq_nivel_dano.currval from dual;

select * from nivel_dano where dan_id = 5;
-- Verificando as diferentes matrículas no tabelao
select distinct matricula from tabelao;

-- Criando sequence e trigger para mapear os ids
create sequence sq_aeronave nocache;
create trigger tg_sq_aeronave before insert on aeronave for each row
begin
    :new.aer_id := sq_aeronave.nextval;
end;

-- Inserindo no voo origem os campos, já com a sequence e o trigger funcionando
insert into aeronave(matricula)(
    select distinct matricula from tabelao
);

insert into aeronave (
    select 
        null,
        matricula,
        assento
    from
        tabelao
);


-- script abaixo retorna erro!
update tabelao set 
    matricula = (
        select aer_id from aeronave left join tabelao on 
        aeronave.aer_matricula = tabelao.matricula
    );

-- Para verificar se a sequence foi usada

SELECT sq_aeronave.currval from dual;

select * from nivel_dano where dan_id = 5;
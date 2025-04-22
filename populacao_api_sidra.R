 #lendo e tratando os dados de municípios (tabela 4709 do Sidra )
 pop_2022 <- httr::GET('https://apisidra.ibge.gov.br/values/t/4709/g/87/v/93/p/all') %>%
  httr::content(.) 

 col_names <- pop_2022[[1]] %>% unlist %>% unname
 col_names <- gsub(' ','\\_', tolower(col_names))
 #pop_2022 <- do.call('rbind', pop_2022[-1]) %>% as.data.frame
 pop_2022 <- purrr::map_df(pop_2022[-1], function(x){unlist(x) %>% rbind %>% as.data.frame })
 names(pop_2022) <- col_names

 #colocando variáveis para numérico
 pop_2022$valor <- as.numeric(pop_2022$valor)
 pop_2022$municipio <- substr(pop_2022$`município,_em_ordem_de_código_de_uf_e_código_de_município_(código)`,1,6) %>% as.numeric #deixando no formato de 6 dígitos
 #criando vetor para faixa de população
 pop_2022$faixa_pop <- cut(pop_2022$valor, breaks = c(-Inf, 5000, 20000, 50000, 100000, 500000, Inf),
                        labels = c('Até 5.000', '5001-20.000', '20.001-50.000', '50.001-100.000', '100.001-500.000', '>500.000'))

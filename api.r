########## Extracao pela API em JSON ###########

# Instalar pacotes necessários
install.packages(c("tidyverse","nycflights13","jsonlite","httr","magrittr","highcharter"))

# Carregar
suppressMessages(require(readr))               # usado para fazer a leitura de dados csv e txt 
suppressMessages(require(readxl))              # usado para fazer leitura de dados xls ou xlsx
suppressMessages(require(nycflights13))        # usado para coletar dados tomados como exemplo
suppressMessages(require(jsonlite))            # usado para fazer a leitura de dados em JSON
suppressMessages(require(httr))                # usado para fazer requisições às APIs
suppressMessages(require(magrittr))            # usado para operações em pipeline
suppressMessages(require(lubridate))

# Baixar o arquivo
reserv = paste0("http://api.funceme.br/rest/acude/reservatorio?limit=1000",collapse = ",")

reserv1=jsonlite::fromJSON(reserv,simplifyDataFrame = T,flatten = T)
head(reserv1)
reserv2<-as.data.frame(reserv1)
head(reserv2)
reserv2<-reserv2[,-c(1:7)]
head(reserv2)
colnames(reserv2)<-stringr::str_remove(colnames(reserv2),"list.")

reserv3<-reserv2[,-c(7,43)]
typeof(reserv3)
reserv3<-as.data.frame(reserv3)
str(reserv3)

for(j in 1:ncol(reserv2)){
  if(is.list(reserv2[,j])==TRUE)
  reserv2[,j]<-as.character(reserv2[,j])
j=+1
}

write.table(reserv2,"C:/Users/lanak/Dropbox/Web Scraping - R/reserv1.csv",
            sep=";",dec=",",row.names = F,col.names = T)

#---------------------------------------------------------------#
# Para rodar este programa  deixe no objeto fit.model a saída 
# do  ajuste  da  regressão com  erro normal. Deixe  os dados 
# disponíveis  através do comando attach(...). Depois  use  o 
# comando source(...) no S-Plus ou R para executar o programa. 
# A sequência de comandos é a seguinte:
#
#        > fit.model <- ajuste
#        > attach(dados)
#        > source("Alavanca.R")
#
# A saída terá quatro gráficos: de pontos de alavanca, de pontos
# influentes  e  dois de resíduos. Para identificar os pontos
# que  mais  se destacam usar o comando identify(...). Se por
# exemplo se destacam três pontos no plot(fitted(fit.model),h,...), 
# após esse comando coloque
#     
#        > identify(fitted(fit.model),h,n=3)
#
# O mesmo pode ser feito nos demais gráficos. Nos gráficos de 
# resíduos foram traçados os limites ylim=c(a-1,b+1), onde a
# é o menor valor e b o maior valor para o resíduo..Mude esses 
# limites  se  necessário.Para voltar a ter apenas um gráfico 
# por tela faça o seguinte:
#
#        > par(mfrow=c(1,1))
# 
#---------------------------------------------------------------#
#
X <- model.matrix(fit.model)
n <- nrow(X)
p <- ncol(X)
H <- X%*%solve(t(X)%*%X)%*%t(X)
h <- diag(H)
lms <- summary(fit.model)
s <- lms$sigma ## Quadrado médio do resíduo
r <- resid(lms)
ts <- r/(s*sqrt(1-h)) ### Resíduo estudentizado
di <- (1/p)*(h/(1-h))*(ts^2) ## Distância de Cook
si <- lm.influence(fit.model)$sigma ##raiz do quadrado médio do resíduo
### com a i-ésima observação removida
tsi <- r/(si*sqrt(1-h)) ### Resíduo R-Student
a <- max(tsi)
b <- min(tsi)
par(mfrow=c(2,2))

## Valores ajustados vs Resíduos R-Student
plot(fitted(fit.model),tsi,xlab="Valores Ajustados", 
ylab="Residuo Studentizado", ylim=c(b-1,a+1), pch=16)
abline(2,0,lty=2)
abline(-2,0,lty=2)
title(sub="(a)")
identify(fitted(fit.model),tsi, n=2)

### Gráfico dos resíduos RStudent
plot(tsi,xlab="Indice", ylab="Resíduo Studentizado",
ylim=c(b-1,a+1), pch=16)
abline(2,0,lty=2)
abline(-2,0,lty=2)
identify(tsi, n=2)
title(sub="(b)")

### o "plot" faz o gráfico dos pontos hii na ordem de obtenção dos dados
plot(h,xlab="Indice", ylab="Medida h", pch=16, ylim=c(0,1))
### Cut é o ponto de corte para ponto de alavanca
cut <- 2*p/n
### Insere no gráfico o ponto de corte de alavanca
abline(cut,0,lty=2)

### "identify" identifica o ponto próximo ao click do mouse
identify(h, n=2)
title(sub="(c)")
#
## Faz o gráfico da distância de Cook

if(max(di) < 1.0) plot(di,xlab="Indice", ylab="Distancia de Cook", ylim=c(0,1.5),pch=16)  else  
plot(di,xlab="Indice", ylab="Distancia de Cook",pch=16)
abline(1,0,lty=2)
identify(di, n=2)
title(sub="(d)")
#

#

#---------------------------------------------------------------#
%{  
   #include "syntaxic.tab.h"
   #include "ts.h"
   #include<stdio.h>
   #include<stdlib.h>
   #include<string.h>
   extern int nb_ligne;
   extern int col;
   extern YYSTYPE yylval;
%}
lettreM [A-Z]
lettre [a-zA-Z]
chifre [0-9]
IDF {lettreM}({lettre}|{chifre})*
CST_CHAR      \'[^']\'
CST_STRING    \"[^"$&%@#]*\"
CST_INT  ({chifre}+|"\("[+-]{chifre}+"\)")
CST_FLOAT	 ({chifre}+"."{chifre}+|\([+-]{chifre}+"."{chifre}+\))
signe_acc \"[$%#&]\"
signe_disp \"({chifre}|{lettre}|[ '])+[$%#&]\"

%%
  
"IDENTIFICATION DIVISION."   {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1); printf("mot_cle_IDENTIFICATION_DIVISION reconnue \n"); col = col+strlen(yytext); return mc_idenDiv;}
"PROGRAM-ID."     {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1); printf("mot_cle_PROGRAM reconnue  \n"); col = col+strlen(yytext); return mc_progId ;}
"DATA DIVISION."  {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1); printf("mot_cle_DATA  reconnue \n"); col = col+strlen(yytext); return mc_dataDiv;} 
"WORKING-STORAGE SECTION."   {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1); printf("mot_cle_WORKING-STORAGE SECTION reconnue \n"); col = col+strlen(yytext); return mc_worStoSec;}
"PROCEDURE DIVISION."   {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1); printf("mot_cle_PROCEDURE DIVISION reconnue \n");col = col+strlen(yytext); return mc_ProcDiv;}
"STOP RUN."       {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1); printf("mot_cle_STOP RUN reconnue \n");col = col+strlen(yytext);return mc_stop;}
"."         {rechercher(yytext,"Separateur",0,0, 2);; printf("fin reconnue \n"); col = col+strlen(yytext);return mc_point;}
INTEGER   {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1); printf("mot_cle_INTEGER reconnue \n");col = col+strlen(yytext);return mc_int;}
FLOAT     {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1); printf("mot_cle_FLOAT reconnue \n");col = col+strlen(yytext);return mc_float;}
CHAR      {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1); printf("mot_cle_CHAR reconnue \n");col = col+strlen(yytext);return mc_char;}
STRING    {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1); printf("mot_cle_STRING reconnue \n");col = col+strlen(yytext);return mc_str;}
CONST     {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1);printf("mot_cle_CONST reconnue \n");col = col+strlen(yytext);return mc_const;}

{signe_acc} {printf("signe accept reconnue \n",yytext);col+=yyleng;yylval.strr=strdup(yytext);return acc_text;}
{signe_disp} {printf("message dispaly reconnue \n",yytext);col+=yyleng;yylval.strr=strdup(yytext);return disp_text;}

SIZE             {rechercher(yytext,"MC"," ",0, 1);	col+=strlen(yytext);      printf("MC size reconnu \n");                    return mc_size;   }
LINE             {rechercher(yytext,"MC"," ",0, 1);	col+=strlen(yytext);      printf("MC line reconnu\n");                     return mc_line;   }

"+"       { rechercher(yytext,"Separateur",0,0, 2); printf("addition reconnue : %s \n",yytext);col = col+strlen(yytext);return mc_somme; }
"-"       {rechercher(yytext,"Separateur",0,0, 2); printf("Subtraction reconnue : %s \n",yytext);col = col+strlen(yytext);return mc_sous;}
"/"       {rechercher(yytext,"Separateur",0,0, 2); printf("division reconnue : %s \n",yytext);col = col+strlen(yytext);return mc_div;}
"*"       {rechercher(yytext,"Separateur",0,0, 2); printf("multi reconnue : %s \n",yytext);col = col+strlen(yytext);return mc_prod;}
"|"       {rechercher(yytext,"Separateur",0,0, 2); printf("Separateur reconnue : %s \n",yytext);col = col+strlen(yytext);return mc_bar;}
AND     {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1); printf("mot_cle_ET reconnu \n"); col = col+strlen(yytext);return mc_and;}
OR      {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1) ; printf("mot_cle_OU reconnu \n"); col = col+strlen(yytext); return mc_or;}
NOT     {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1) ;printf("mot_cle_NEGATION reconnu \n"); col = col+strlen(yytext);return mc_not;}
G       {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1);printf("mot_cle_SUP reconnu \n");col = col+strlen(yytext);return mc_g;} 
L       {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1); printf("mot_cle_INF reconnu \n");col = col+strlen(yytext);return mc_l;}
GE      {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1); printf("mot_cle_SUP_OU_EGAL reconnu \n"); col = col+strlen(yytext);return mc_ge;} 
LE      {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1); printf("mot_cle_INF_OU_EGAL reconnu \n");col = col+strlen(yytext);return mc_le;}
EQ      {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1); printf("mot_cle_EGAL reconnu \n");  col = col+strlen(yytext);return mc_eq;}
"("       { rechercher(yytext,"Separateur",0,0, 2); printf("parentheseO reconnue \n");col = col+strlen(yytext);return par_ouv;}
")"       { rechercher(yytext,"Separateur",0,0, 2); printf("parentheseF reconnue \n");col = col+strlen(yytext);return par_fer;}
ACCEPT    {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1); printf("mot_cle_ACCEPT reconnue \n");col = col+strlen(yytext);return mc_acc;}
DISPLAY   {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1); printf("mot_cle_DISPLAY reconnue \n");col = col+strlen(yytext);return mc_dis;}
IF        {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1); printf("mot_cle_IF reconnue \n");col = col+strlen(yytext);return mc_if ;}
ELSE      {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1); printf("mot_cle_ELSE reconnue \n");col = col+strlen(yytext);return mc_else;}
END       {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1); printf("mot_cle_END  reconnue \n");col = col+strlen(yytext);return mc_end;}
":"       {rechercher(yytext,"Separateur",0,0, 2); printf("deuxP  reconnue \n");col = col+strlen(yytext);return mc_dblpoint;}
MOVE      {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1); printf("mot_cle_MOVE  reconnue \n");col = col+strlen(yytext);return mc_mov;}
TO        {yylval.strr=strdup(yytext);rechercher(yytext,"MC"," ",0, 1); printf("mot_cle_TO reconnue \n");col = col+strlen(yytext);return mc_to;}
"@"       {rechercher(yytext,"Separateur",0,0, 2) ;printf("Entite Lexical reconnue %s \n" , yytext ); col = col + strlen(yytext); return mc_arobaz;} 
{CST_CHAR}  { rechercher (yytext,"CONST CHAR ","Char",atof(yytext), 0);printf("caractere reconnue %s \n", yytext ); col = col+strlen(yytext); return chara;}
{CST_STRING} { rechercher (yytext,"CONST STRING ","STRING",atof(yytext), 0) ;printf("chaine de caractere reconnue %s \n" , yytext ); col = col+strlen(yytext); return str;}
"#"(.*[\n!]?.*)*"!"  {printf("commentaire reconnu : %s \n",yytext);col = col+strlen(yytext); return cmt;}
{IDF}     {if(yyleng<8) {yylval.strr=strdup(yytext);rechercher (yytext,"IDF ","",0, 0); printf("IDF reconnue : %s \n",yytext); return idf;}
           else {printf("erreur lexicale : IDF trop long : %s \n",yytext); break ;}}
{CST_INT}  {if(atoi(yytext)<-32768||atoi(yytext)>32768){
	        printf("integer invalide ligne:%d,colonne:%d",nb_ligne,col);
	        }
	        else{
		    yylval.entier=atoi(yytext); 
            rechercher (yytext,"CONST INT","INT",atof(yytext), 0);
             printf("Entite Lexical reconnue %s \n" , yytext );
             col = col + strlen(yytext);
             return integer;}} 
{CST_FLOAT} { rechercher (yytext,"CONST FLOAT ","FLOAT",atof(yytext), 0) ;printf("REEL reconnue : %s \n",yytext);col = col+strlen(yytext); return flo;}

"="    {printf("affectation reconnue \n");col = col+strlen(yytext);return mc_aff;}
[ \t]
\n    {nb_ligne++; col =1;}
. printf ("Erreur lexicale : Entite lexicale non reconnue %s a la ligne %d la colonne %d\n",yytext, nb_ligne,col);
%%


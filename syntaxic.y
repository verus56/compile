%{
	
	char sauv_opr[20];
	char sauv_type[20];
	int sauv_operande;
	int nb_ligne=1;
	int col=1;
	int ok=0;
	int k=0;
%}
%union{
	int entier;
	char* strr;
	float flt;
}
%start programme

%token  mc_idenDiv mc_progId mc_dataDiv mc_worStoSec mc_ProcDiv mc_stop  <strr>mc_int <strr>mc_float <strr>mc_char <strr>mc_str <strr>mc_const <entier>integer <flt>flo <strr>chara <strr>idf_tab <strr>mc_and <strr>mc_or <strr>mc_not <strr>mc_g <strr>mc_l <strr>mc_ge <strr>mc_eq <strr>mc_le <strr>mc_di  <strr>par_fer <strr>par_ouv <strr>mc_acc <strr>mc_dis <strr>acc_text <strr>disp_text <strr>mc_if <strr>mc_else <strr>mc_end <strr>mc_mov <strr>mc_to <strr>mc_aff <strr>mc_somme <strr>mc_sous <strr>mc_prod <strr>mc_div <strr>mc_dblpoint <strr>mc_bar <strr>mc_arobaz <strr>idf <strr>mc_point err <strr>str  <strr>cmt mc_size mc_line

%%

programme: entete partie_declaration partie_instruction mc_stop
;

entete: mc_idenDiv mc_progId idf mc_point {insererType($3,"NOM PROG");}
;
partie_declaration: mc_dataDiv mc_worStoSec declaration 
;
declaration: variable declaration {}
			 | tableau declaration
			 | constante declaration
			 | 
;
variable: list_idf mc_point
;
list_idf: idf type {   if(DoubleDeclaration($1)==0) {insererType($1,sauv_type);}
                               else{printf("\nErreur semantique L.%d C.%d: Double declaration de l'entite %s\n",nb_ligne,col,$1);return -1;}						   
							}
		| idf mc_bar list_idf  {   if(DoubleDeclaration($1)==0) {insererType($1,sauv_type);}
                               else{printf("\nErreur semantique L.%d C.%d: Double declaration de l'entite %s\n",nb_ligne,col,$1);return -1;}						   
							}
;
constante: mc_const idf mc_aff valeur mc_point {if(DoubleDeclaration($2)==0) {insererType($2,"cst");}
                               else{printf("\nErreur semantique L.%d C.%d: Double declaration de l'entite %s\n",nb_ligne,col,$2);return -1;}						   
							}
;
valeur: str 
	   |integer 
	   |chara 
	   |flo 
;
type: mc_int {strcpy(sauv_type,$1);}
	  | mc_float {strcpy(sauv_type,$1);}
	  | mc_char {strcpy(sauv_type,$1);}
	  | mc_str {strcpy(sauv_type,$1);}
;
tableau: idf mc_line integer mc_size integer type mc_point { 
																	 if(DoubleDeclaration($1)==0)	
																		{insererType($1,sauv_type);
																		 
																		 }
																	   else { if(DoubleDeclaration($1)==-1)
																		{printf("\nErreur Semantique : Double declaration a la ligne : %d et la colonne : %d ",nb_ligne,col);
																		return -1;}
																	  }
																	if (($5<$3) || ($5<0))
																	{printf("\nErreur Semantique : Fausse taille  a la ligne :%d  et la colonne : %d\n",nb_ligne,col);
																	return -1;}
																	   }
partie_instruction: mc_ProcDiv liste_instruction 
;
liste_instruction: instruc liste_instruction
				   |
;
instruc:affectation 
		| lire 
		| ecrire 
		| condition
		| boucle
;
affectation: idf mc_aff idf mc_point {if(DoubleDeclaration($1)==0) {printf("\nErreur semantique L.%d C.%d: variable non declaree de l'entite %s \n",nb_ligne,col,$1);return -1;}
			                          else {if(verifCst($1)==-1) {printf("\nErreur semantique L.%d C.%d: constante affectee de l'entite %s\n",nb_ligne,col,$1);return -1;}
                                      else if(CompatibleType($1,$3) != 1) {printf("\nErreur semantique Type de variables incompatibles a la ligne %d et a la colonne %d \n",nb_ligne,col,$1);return -1;}}}
            |idf mc_aff exp_aff mc_point {if(DoubleDeclaration($1)==0) {printf("\nErreur semantique L.%d C.%d: variable non declaree de l'entite %s \n",nb_ligne,col,$1);ok=0;}else if(verifCst($1)==-1) {printf("\nErreur semantique L.%d C.%d: constante affectee de l'entite %s\n",nb_ligne,col,$1);}
			                              }
			|idf mc_aff CST mc_point {	
			   								

			   					       if (DoubleDeclaration($1)==0)
								           {printf("Erreur Semantique : la variable %s est non Declarer dans la  partie declaration  a la ligne %d et la colonnes %d",$1,nb_ligne,col);
								            return -1;}
								        else if (verifCst($1)==-1) {
												

															printf("Erreur semantique : le %s c'est une constante , tu peut pas fait une affectation  , a la ligne %d et la colonne : %d \n",$1,nb_ligne,col);
															return -1;
															
															}
															 
									}						  
;
/*__________________________________________________________________________________________________________________________*/

CST :chara 
	|str  	
	|CST_NUM;
/*__________________________________________________________________________________________________________________________*/

CST_NUM : integer 
		| flo 
		

/*__________________________________________________________________________________________________________________________*/										  
exp_aff: expr
        |EXPRESSION_PAR 
;
EXPRESSION_PAR : // An expression that can generate parenthesis
		| par_ouv expr par_fer opr expr
		| par_ouv expr par_fer opr operand {if(strcmp(sauv_opr,"/")==0 && sauv_operande==0) {printf("Erreur semantique,division par zero:L.%d C.%d\n",nb_ligne,col);}strcmp(sauv_opr,"")==0;sauv_operande==-1;return -1;}
		| par_ouv expr par_fer opr EXPRESSION_PAR
		| par_ouv EXPRESSION_PAR par_fer opr operand {if(strcmp(sauv_opr,"/")==0 && sauv_operande==0) {printf("Erreur semantique,division par zero:L.%d C.%d\n",nb_ligne,col);}strcmp(sauv_opr,"")==0;sauv_operande==-1;return -1;}
		| par_ouv EXPRESSION_PAR par_fer operand expr
		| par_ouv EXPRESSION_PAR par_fer opr expr
		| par_ouv expr par_fer
		| par_ouv EXPRESSION_PAR par_fer
				
;
lire: mc_acc par_ouv acc_text mc_dblpoint mc_arobaz idf par_fer mc_point {if(DoubleDeclaration($6)==0){printf("erreur semantique:variable non declaree:L.%d C.%d de l entite %s\n",nb_ligne,col,$6);return -1;} if(verif_compatibilite($6,$3)==-1){printf("erreur semantique:sign incomaptible avec type de la variable L.%d C.%d \n",nb_ligne,col);return -1;}}
;
ecrire: mc_dis par_ouv disp_text mc_dblpoint idf par_fer mc_point {if(DoubleDeclaration($5)==0){printf("erreur semantique:variable non declaree:L.%d C.%d de l entite %s\n",nb_ligne,col,$5);} if(verif_compatibilite($5,$3)==-1){printf("erreur semantique:sign incomaptible avec type de la variable L.%d C.%d \n",nb_ligne,col);return -1;}}
;

condition: mc_if par_ouv expression_cond expression_cond2 par_fer2 mc_dblpoint liste_instruction partiedeux mc_end
;
partiedeux: mc_else mc_dblpoint liste_instruction
           |
;
par_fer2: par_fer 
		  |
;
expression_cond: expr mc_point operateur_comp mc_point expr 
				 | mc_not expression_cond
				 |
;
operateur_comp: mc_g
				| mc_l 
				| mc_ge
				| mc_le 
				| mc_eq 
				| mc_di
;
expression_cond2: operateur_logiq expression_cond expression_cond2
				|
;
operateur_logiq: mc_point mc_or mc_point
				 | mc_point mc_and mc_point
;
boucle: mc_mov idf mc_to idf liste_instruction mc_end mc_point {if (DoubleDeclaration($2)==0 || DoubleDeclaration($4)==0)
													
													{printf("Erreur Semantique : l 'idf est non Declarer dans la  partie declaration  a la ligne %d et la colonne : %d\n",nb_ligne,col);
													return -1;}
													else if (get_type($2) != 1 || get_type($4) != 1)
													{
													printf("Erreur semantique : incompatibilite de Type  a la ligne  %d et la colonne :%d\n", nb_ligne,col); 
													return -1 ;
													}
												}

	 |mc_mov idf mc_to integer liste_instruction mc_end mc_point { if (DoubleDeclaration($2)==0)
													
													{printf("Erreur Semantique : l'idf est non Declarer dans la  partie declaration  a la ligne %d et la colonne \n",nb_ligne,col);
													return -1;}
													else if (get_type($2) != 1)
													{
													printf("Erreur semantique : incompatibilite de Type  a la ligne %d et la colonne\n", nb_ligne,col); 
													return -1;
													}
	 												} 	 		
     |mc_mov integer mc_to integer liste_instruction mc_end mc_point {if($2>$4) {printf("Erreur semantique   a la ligne %d et la colonne\n", nb_ligne,col);return -1;}}
;
expr:operand opr operand {if(strcmp(sauv_opr,"/")==0 && sauv_operande==0) {printf("Erreur semantique,division par zero:L.%d C.%d\n",nb_ligne,col); return -1;}strcmp(sauv_opr,"")==0;sauv_operande==-1;}
     |operand 
;
opr: mc_prod 
     |mc_div {strcpy(sauv_opr,"/");}
     |mc_somme 
	 |mc_sous
;
operand: idf {if(DoubleDeclaration($1)==0) {printf("erreur semantique:variable non declaree:L.%d C.%dde l'entite %s\n",nb_ligne,col,$1);return -1;}}
		 | integer {sauv_operande=$1;k=1;}
		 | flo {sauv_operande=-1;}
;
%%
main(){
	 initialisation();
     yyparse();
     afficher();	
}
yywrap(){return 1;}
yyerror(char*msg){
printf("\nErreur syntaxique L.%d C.%d\n",nb_ligne,col);
}
 

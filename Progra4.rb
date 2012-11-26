########################################################################
#                 INSTITUTO TECNOLOGICO DE COSTA RICA                  #
#                      LENGUAJES DE PROGRAMACION                       #
#                         IV TAREA PROGRAMADA                          #
#                        BUSCADOR DE IMAGENES                          #
#                             INTEGRANTES                              #
#                            LESLIE BECERRA                            #
#                           BAYRON PORTUGUEZ                           #
#                            BRAULIO ALPIZAR                           #
#                                 FECHA:                               #
#                            NOVIEMBRE DE 2012                         #
########################################################################

# Importacion de librerias
require 'rubygems'
require 'erb'
require 'sinatra'
require 'flickraw'

# ==============================================================================#
# ------------------------------VARIABLES GLOBALES------------------------------#
$Imagen1;$Imagen2;$Imagen3;$Imagen4;$Imagen5;$Imagen6;$Imagen7;$Imagen8;$Imagen9
$Titulo1;$Titulo2;$Titulo3;$Titulo4;$Titulo5;$Titulo6;$Titulo7;$Titulo8;$Titulo9
$Autor1;$Autor2;$Autor3;$Autor4;$Autor5;$Autor6;$Autor7;$Autor8;$Autor9
$Url1;$Url2;$Url3;$Url3;$Url4;$Url5;$Url6;$Url7;$Url8;$Url9
$limite=0;$Num_de_foto=0;$cant_resultados=0;$mult=1
$fotos=[]

#===============================================================================#

#==========================================#
# --------------CLASE IMAGEN-------------- #
# ---------------------------------------- #
# Atributos:                               #
# @Title: str con titulo de la imagen      #
# @Autor: str con nombre del autor         #
# @Url: str con url de la imagen           #
# @Url_Origen: str con url de origen       #
#==========================================#

class Imagen
	@Title
	@Autor
	@Url
	@Url_Origen
	attr_reader :Title, :Autor, :Url,:Url_Origen
	attr_writer :Title, :Autor, :Url,:Url_Origen
	def initialize(title,autor,url,url_origen)
		@Title=title
		@Autor=autor
		@Url=url
		@Url_Origen=url_origen
		end

	end
#===========================================#

# Metodo get de llamada a la pagina de inicio
get '/' do

	erb :Inicio

end


def multiplo()

	while ($cant_resultados>=$limite)
		$limite=9*$mult
		$mult+=1
	
	end
end

# Metodo de actualizacion de variables
def actualiza()
	if ($fotos[$Num_de_foto].Url !="") and ($Num_de_foto<$cant_resultados)
		$Url1=$fotos[$Num_de_foto].Url_Origen;$Url2=$fotos[$Num_de_foto+1].Url_Origen;$Url3=$fotos[$Num_de_foto+2].Url_Origen
		$Url4=$fotos[$Num_de_foto+3].Url_Origen;$Url5=$fotos[$Num_de_foto+4].Url_Origen;$Url6=$fotos[$Num_de_foto+5].Url_Origen
		$Url7=$fotos[$Num_de_foto+6].Url_Origen;$Url8=$fotos[$Num_de_foto+7].Url_Origen;$Url9=$fotos[$Num_de_foto+8].Url_Origen   	
		
		$Imagen1=$fotos[$Num_de_foto].Url;$Imagen2=$fotos[$Num_de_foto+1].Url;$Imagen3=$fotos[$Num_de_foto+2].Url;
		$Imagen4=$fotos[$Num_de_foto+3].Url;$Imagen5=$fotos[$Num_de_foto+4].Url;$Imagen6=$fotos[$Num_de_foto+5].Url;
		$Imagen7=$fotos[$Num_de_foto+6].Url;$Imagen8=$fotos[$Num_de_foto+7].Url;$Imagen9=$fotos[$Num_de_foto+8].Url

	
		$Titulo1=$fotos[$Num_de_foto].Title;$Titulo2=$fotos[$Num_de_foto+1].Title;$Titulo3=$fotos[$Num_de_foto+2].Title;
		$Titulo4=$fotos[$Num_de_foto+3].Title;$Titulo5=$fotos[$Num_de_foto+4].Title;$Titulo6=$fotos[$Num_de_foto+5].Title;
		$Titulo7=$fotos[$Num_de_foto+6].Title;$Titulo8=$fotos[$Num_de_foto+7].Title;$Titulo9=$fotos[$Num_de_foto+8].Title

	
		$Autor1=$fotos[$Num_de_foto].Autor;$Autor2=$fotos[$Num_de_foto+1].Autor;$Autor3=$fotos[$Num_de_foto+2].Autor;
		$Autor4=$fotos[$Num_de_foto+3].Autor;$Autor5=$fotos[$Num_de_foto+4].Autor;$Autor6=$fotos[$Num_de_foto+5].Autor;
		$Autor7=$fotos[$Num_de_foto+6].Autor;$Autor8=$fotos[$Num_de_foto+7].Autor;$Autor9=$fotos[$Num_de_foto+8].Autor
	
		
		$Num_de_foto = $Num_de_foto+9

		redirect '/Result'
	
	
	else
		redirect '/No_result'
	end
	
end


# Tetodo post de busqueda de fotos en la pagina de Flickr y llenado de fotos de resultados
post '/flickr' do

	$Num_de_foto=0;$limite=0;$cant_resultados=0;i=0
	$fotos=[]

	FlickRaw.api_key = '7c4f55681b80e4da3e07c514c1fde776'  
	FlickRaw.shared_secret = '7a133613ca5ed138' 
 
	user= params[:campo1]
	resultados=flickr.photos.search(:tags =>user)
    
	if params[:campo2].to_i < 100
		$cant_resultados = params[:campo2].to_i
	
	else
		$cant_resultados = 100
	end
	multiplo()
	$mult=1

	while (i !=$limite)
		if i>=($cant_resultados) or (i>= resultados.length)
			imagen=Imagen.new("","","","")
	
		else
			info = flickr.photos.getInfo(:photo_id => resultados[i].id)
			imagen=Imagen.new(info.title,info.owner.username,FlickRaw.url_b(info),FlickRaw.url_photopage(info))
			puts imagen.Url_Origen
		end

		$fotos+=[imagen]
	  	i+=1
		
	end
	actualiza()
end

# Metodo post para siguiente pagina de resultados
post '/siguiente' do

	if ($Num_de_foto<$limite)

		actualiza()

	else

		redirect '/No_result'

	end	
	
end


#Metodo post para pagina anterior de resultados
post '/anterior' do
	if ($Num_de_foto>9)

		$Num_de_foto = $Num_de_foto-9
		$Imagen1=$fotos[$Num_de_foto-9].Url
		$Imagen2=$fotos[$Num_de_foto-8].Url
		$Imagen3=$fotos[$Num_de_foto-7].Url
		$Imagen4=$fotos[$Num_de_foto-6].Url
		$Imagen5=$fotos[$Num_de_foto-5].Url
		$Imagen6=$fotos[$Num_de_foto-4].Url
		$Imagen7=$fotos[$Num_de_foto-3].Url
		$Imagen8=$fotos[$Num_de_foto-2].Url
		$Imagen9=$fotos[$Num_de_foto-1].Url

	end

	redirect '/Result'

end


# Metodo get que direcciona a la cuadricula de resultados
get '/Result' do

	erb :Resultados

end

# Metodo get que llama a la pagina especial de error en caso de no enNum_de_fotorar resultados a la busqueda
get '/No_result' do

	erb :SinResultados

end




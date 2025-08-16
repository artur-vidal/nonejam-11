// OBJETO PAI DE TODAS AS ENTIDADES
// Variáveis de velocidade
velh = 0
velv = 0
max_vel = 150

// Variáveis de desenho de sprite
xscale = 1
yscale = 1
angle = 0
alpha = 1

facing = Directions.DOWN

image_speed = 0 // tirando velocidade padrão

sprite = noone
sprite_fps = 10
image_ind = 0

image_spd = 1

manual_depth = false

///@desc Função para animar um sprite individual em uma entidade
animate_sprite = function(sprite_asset, fps){
    // Checando se a minha sprite atual é a que eu deveria estar usando, se não, eu reseto o index
	if(sprite != sprite_asset){
		image_ind = 0
	}
	
	sprite = sprite_asset
	
	// Pegando quantos frames minha sprite atual tem
	var _image_num = sprite_get_number(sprite)
	
	//Aumentando o valor do index com base na velocidade
    var _add = fps * image_spd * RELATIVE_DT
	image_ind += _add
	
    // Rodando script de fim de animação quando ela acabar
    if(image_ind + _add > _image_num) {
        image_ind = 0
        animation_end()
    }
        
	// Zerando o image_ind quando acabar a animação
	// image_ind %= _image_num
}

///@desc Usado para entidades que olham nas quatro direções
animate_sprite_group = function(group){
	
    animate_sprite(group[facing], group[4])
    
}

///@desc Roda quando a animação acabar
animation_end = function(){
    
    // nada por padrão
    
}
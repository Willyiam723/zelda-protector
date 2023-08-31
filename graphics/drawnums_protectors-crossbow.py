'''
Adds numbers to a sprite sheet for easy reference.
'''
from PIL import Image
from PIL import ImageFont
from PIL import ImageDraw

filePathNoPNG = 'protectors/crossbow'

TILE_SIZE_x = 45.5
TILE_SIZE_y = 32
# size of tile sheet on Y and X axis in tiles; replace these with something positive
TILES_WIDE = int(273/TILE_SIZE_x)
TILES_HIGH = int(128/TILE_SIZE_y)

if __name__ == '__main__':

    # replace 'tiles.png' with your sprite sheet
    img = Image.open(filePathNoPNG + '.png')
    draw = ImageDraw.Draw(img)

    # custom small font, good for small tile sets
    font = ImageFont.truetype('04B_03__.TTF', 8)
    
    # keep track of which tile we're adding text to
    counter = 1

    for y in range(TILES_HIGH):
        for x in range(TILES_WIDE):
            draw.text((x * TILE_SIZE_x + 1, y * TILE_SIZE_y), str(counter), (0, 0, 0), font=font)
            draw.text((x * TILE_SIZE_x, y * TILE_SIZE_y + 1), str(counter), (0, 0, 0), font=font)
            draw.text((x * TILE_SIZE_x, y * TILE_SIZE_y), str(counter), (255, 0, 255), font=font)
            counter += 1
    
    # save as renamed tile sheet
    img.save(filePathNoPNG + '_numbered.png')

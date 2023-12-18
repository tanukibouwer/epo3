from PIL import Image
import numpy as np
import csv

paths = ('C:/Users/Kevin/Desktop/code/epo3-1/VGA/sprite_images/png_format/eight_mine.png','C:/Users/Kevin/Desktop/code/epo3-1/VGA/sprite_images/png_format/eight_parama.png', 'C:/Users/Kevin/Desktop/code/epo3-1/VGA/sprite_images/png_format/five_parama.png','C:/Users/Kevin/Desktop/code/epo3-1/VGA/sprite_images/png_format/four_parama.png','C:/Users/Kevin/Desktop/code/epo3-1/VGA/sprite_images/png_format/nine_mine.png', 'C:/Users/Kevin/Desktop/code/epo3-1/VGA/sprite_images/png_format/nine_parama.png', 'C:/Users/Kevin/Desktop/code/epo3-1/VGA/sprite_images/png_format/one_mine.png', 'C:/Users/Kevin/Desktop/code/epo3-1/VGA/sprite_images/png_format/one_parama.png', 'C:/Users/Kevin/Desktop/code/epo3-1/VGA/sprite_images/png_format/p1_mine.png', 'C:/Users/Kevin/Desktop/code/epo3-1/VGA/sprite_images/png_format/p1_parama.png', 'C:/Users/Kevin/Desktop/code/epo3-1/VGA/sprite_images/png_format/seven_mine.png', 'C:/Users/Kevin/Desktop/code/epo3-1/VGA/sprite_images/png_format/seven_parama.png', 'C:/Users/Kevin/Desktop/code/epo3-1/VGA/sprite_images/png_format/six_parama.png', 'C:/Users/Kevin/Desktop/code/epo3-1/VGA/sprite_images/png_format/three_mine.png', 'C:/Users/Kevin/Desktop/code/epo3-1/VGA/sprite_images/png_format/three_parama.png', 'C:/Users/Kevin/Desktop/code/epo3-1/VGA/sprite_images/png_format/two_parama.png', 'C:/Users/Kevin/Desktop/code/epo3-1/VGA/sprite_images/png_format/zero_mine.png', 'C:/Users/Kevin/Desktop/code/epo3-1/VGA/sprite_images/png_format/zero_parama.png')

# sprites = ()

# open('sprite_output.txt', 'w').close()
# open('C:/Users/Kevin/Desktop/code/epo3-1/VGA/sprite_images/png_format/eight_mine.png', 'r').close()
fp = open('C:/Users/Kevin/Desktop/code/epo3-1/VGA/sprite_images/png_format/sprite_output.txt', 'w')

for path in paths:
    print(path)
    fp.write(path + '\n')
    fp.write('( \n')
    im = Image.open(fp = path)
    array = np.asarray(im)
    # print(array[0][0][0])
    # print(array.shape)
    for row in range(array.shape[0]):
        fp.write('(')
        fp.write('("')
        for pixel in range(array.shape[1]):
            # print((int((array[row][pixel][0]+1)/16)))
            R = bin(int((array[row][pixel][0]+1)/16)-1)[2:]
            G = bin(int((array[row][pixel][1]+1)/16)-1)[2:]
            B = bin(int((array[row][pixel][2]+1)/16)-1)[2:]
            for i in range(4-len(R)):
                # print('hi')
                fp.write('0')
            fp.write(str(R))
            for i in range(4-len(G)):
                fp.write('0')
            fp.write(str(G))
            for i in range(4-len(B)):
                fp.write('0')
            fp.write(str(B))
            if pixel < 15:
                fp.write('"),("')
            else:
                fp.write(')')
            # print(bin(int((array[row][pixel][0]+1)/16)-1)[2:])
        if row < 23:
            fp.write('), \n')
        else:
            fp.write(') \n')
    fp.write('); \n\n')
            


    # for row in (len(array)):
    #     for pixel in (len(array[row])):
    #         print(bin(array[row][pixel][0])[2:])
    # csv.writer(fp, delimiter= ']').writerows(array)
    


fp.close()

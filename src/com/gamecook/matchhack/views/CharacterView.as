/*
 * Copyright (c) 2011 Jesse Freeman
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.gamecook.matchhack.views
{
    import com.gamecook.matchhack.factories.CharacterFactory;

    import flash.display.Bitmap;
    import flash.display.Sprite;

    import uk.co.soulwire.display.PaperSprite;

    public class CharacterView extends PaperSprite
    {

        [Embed(source="../../../../../build/assets/sprites/blood_01.png")]
        private static var BloodImage:Class;

        private var lifeBar:LifeBarView;
        private const PLAYER:String = "player";
        private var characterImage:Bitmap;
        private var container:Sprite;
        private var bloodImage:Bitmap;

        public function CharacterView(name:String, life:int)
        {
            this.name = name;
            container = new Sprite();

            lifeBar = container.addChild(new LifeBarView(life)) as LifeBarView;
            lifeBar.x = -2;
            lifeBar.y = 2;

            if (name == PLAYER)
            {
                characterImage = container.addChild(CharacterFactory.createPlayerBitmap()) as Bitmap;
            }
            else
            {
                characterImage = container.addChild(CharacterFactory.createMonster()) as Bitmap;
            }
            characterImage.x -= 2;
            lifeBar.x += (64 - lifeBar.width);
            container.x -= 32;
            container.y -= 32;

            createImage();

            bloodImage = new BloodImage() as Bitmap;

            super(container, bloodImage);
        }

        private function createImage():void
        {

        }

        public function subtractLife(value:int):void
        {
            lifeBar.subtractTotal(value)
        }

        public function addLife(value:int):void
        {
            lifeBar.addTotal(value)
        }

        public function isDead():Boolean
        {
            return (lifeBar.getTotal() <= 0);
        }

        public function getLife():int
        {
            return lifeBar.getTotal();
        }

        public function getImage():Bitmap
        {
            return characterImage;
        }
    }
}

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
    import flash.display.Bitmap;
    import flash.display.Shape;
    import flash.display.Sprite;

    public class LifeBarView extends Sprite
    {

        [Embed(source="../../../../../build/assets/life_bar_bg.png")]
        private var LifeBarBackground:Class;
        private var life:int;
        private var maxLife:int;
        private var backgroundImage:Bitmap;
        private var lifeBar:Shape;

        public function LifeBarView(life:int, maxLife:int)
        {
            this.life = life;
            this.maxLife = maxLife;

            backgroundImage = addChild(new LifeBarBackground) as Bitmap;

            //Draw Lifebar
            var padding:int = 2;

            lifeBar = addChild(new Shape()) as Shape;
            lifeBar.graphics.beginFill(0xFF0000);
            lifeBar.graphics.drawRect(0, 0, backgroundImage.width - (padding * 2), backgroundImage.height - (padding * 2));
            lifeBar.graphics.endFill();
            lifeBar.x = lifeBar.y = padding;

            updateLifeBar();
        }

        public function setTotal(value:int):void
        {
            life = value;
            updateLifeBar();
        }

        public function getTotal():int
        {
            return life;
        }

        private function updateLifeBar():void
        {
            lifeBar.scaleY = 1 - life / maxLife;
        }
    }
}

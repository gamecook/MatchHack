/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 4/16/11
 * Time: 9:53 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.views {
    import com.gamecook.matchhack.factories.CharacterFactory;

    import flash.display.Bitmap;
    import flash.display.Sprite;

    import uk.co.soulwire.display.PaperSprite;

    public class CharacterView extends PaperSprite{

        [Embed(source="../../../../../build/assets/sprites/blood_01.png")]
        private static var BloodImage : Class;

        private var lifeBar:LifeBarView;
        private const PLAYER:String = "player";
        private var characterImage:Bitmap;
        private var container:Sprite;
        private var bloodImage:Bitmap;

        //public var life:int;

        public function CharacterView(name:String, life:int)
        {
            this.name = name;
            container = new Sprite();

            lifeBar = container.addChild(new LifeBarView(life)) as LifeBarView;

            if(name == PLAYER)
            {
                characterImage = container.addChild(CharacterFactory.createPlayerBitmap()) as Bitmap;
            }
            else
            {
                characterImage = container.addChild(CharacterFactory.createMonster()) as Bitmap;
            }
            characterImage.x -= 5;
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

    }
}

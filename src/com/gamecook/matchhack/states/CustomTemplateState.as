/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 3/18/11
 * Time: 9:17 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.states
{
    public class CustomTemplateState extends AbstractStateObject
    {

        public function CustomTemplateState()
        {
            super(this, "ConfigureCharacterActivity");
        }

        public function get customTemplate():Object
        {
            return _dataObject.customTemplate;
        }

        public function get className():String
        {
            return customTemplate.className;
        }

        public function set className(value:String):void
        {
            customTemplate.className = value;
        }

        public function get name():String
        {
            return customTemplate.name;
        }

        public function set name(value:String):void
        {
            customTemplate.name = value;
        }

        public function set life(life:Number):void
        {
            customTemplate.life = life;
        }

        public function set attackRoll(attackRoll:Number):void
        {
            customTemplate.attackRoll = attackRoll;
        }

        public function set defense(defense:Number):void
        {
            customTemplate.defense = defense;
        }

        public function set potions(potions:Number):void
        {
            customTemplate.potions = potions;
        }
    }
}

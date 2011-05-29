/**
 * Created by IntelliJ IDEA.
 * User: jfreeman
 * Date: 3/22/11
 * Time: 4:01 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.factories
{
    import com.gamecook.matchhack.enums.PlayerClassTemplates;
    import com.gamecook.matchhack.states.ActiveGameState;
    import com.jessefreeman.factivity.utils.ArrayUtil;

    public class NewGameFactory
    {
        private static var DEFAULT_POINTS:int = 20;

        public static function createCoffeeBreakGame(classOptions:Array, darknessOptions:Array, gameModeOptions:Array, mapSizeOptions:Array, showMonsterOptions:Array, dropTreasureOptions:Array, playerValues:Object = null):Boolean
        {
            var activeGameState:ActiveGameState = new ActiveGameState();
            activeGameState.load();

            activeGameState.clear();

            var success:Boolean = false;


            if(!playerValues)
            {
                var playerClass:String = ArrayUtil.pickRandomArrayElement(classOptions);
                var playerObj:Object = PlayerClassTemplates.getTemplate(playerClass);

                playerValues = {name:"Random Name",
                                        maxLife: playerObj.life,
                                        attackRoll: playerObj.attackRoll,
                                        defenseRoll: playerObj.defense,
                                        maxPotions: playerObj.potions,
                                        visibility: playerObj.visibility,
                                        points: DEFAULT_POINTS,
                                        characterPoints: DEFAULT_POINTS}
            }
            // configure ActiveGameState SO
            activeGameState.activeGame = true;
            activeGameState.player = playerValues;

            activeGameState.size = ArrayUtil.pickRandomArrayElement(mapSizeOptions);
            /*activeGameState.gameType = ArrayUtil.pickRandomArrayElement(gameModeOptions);
            activeGameState.darkness = ArrayUtil.pickRandomArrayElement(darknessOptions);
            activeGameState.monstersDropTreasure = ArrayUtil.pickRandomArrayElement(dropTreasureOptions);
            activeGameState.showMonsters = ArrayUtil.pickRandomArrayElement(showMonsterOptions);
*/
            //TODO this needs to be correctly connected
            success = true;
            var error:String = activeGameState.save();

            return success;
        }
    }
}

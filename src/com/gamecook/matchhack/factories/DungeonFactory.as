/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 5/30/11
 * Time: 11:29 AM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.factories
{
    import com.gamecook.frogue.maps.MapPopulater;
    import com.gamecook.frogue.maps.RandomMap;
    import com.gamecook.frogue.tiles.TileTypes;
    import com.gamecook.matchhack.states.ActiveGameState;
    import com.jessefreeman.factivity.utils.ArrayUtil;
    import com.jessefreeman.factivity.utils.TimeMethodExecutionUtil;

    import flash.geom.Point;

    public class DungeonFactory
    {

        public static function createMap(activeState:ActiveGameState):RandomMap
        {
            //Create new Random Map
            var map:RandomMap = new RandomMap();

            // Test to see if the current active state already has map
            if (activeState.map)
            {
                // Get tiles from game state's map object
                map.setTiles(activeState.map.tiles);
            }
            else
            {
                // If there were no tiles, generate a new map
                TimeMethodExecutionUtil.execute("generateMap", map.generateMap, 20, 2);

                var monsters:Array = generateLinearPool(12, ["1","2","3","4","5","6","7","8"]);
                var treasurePool:Array = generateRandomPool(5, ["T"]);

                //TODO Create start position and exit based on game mode.
                var populateMapHelper:MapPopulater = new MapPopulater(map);
                populateMapHelper.populateMap.apply(null, monsters.concat(treasurePool));

                var exitPosition:Point = populateMapHelper.getRandomEmptyPoint();
                map.swapTile(exitPosition, "E");

                activeState.startPositionPoint = populateMapHelper.getRandomEmptyPoint();

                // Swap out some open tiles
                var i:int;
                var total:int = populateMapHelper.getTotalOpenSpaces() * .3;
                for (i = 0; i < total; i++)
                {
                    map.swapTile(populateMapHelper.getRandomEmptyPoint(), TileTypes.getRandomOpenTile());
                }

                activeState.map = map.toObject();
            }

            trace("Map Size", map.width, map.height, "was generated");

            return map;
        }

        private static function generateRandomPool(total:int, items:Array):Array
        {
            var pool:Array = [];
            var i:int;
            for (i = 0; i < total; i ++)
            {
                pool.push(ArrayUtil.pickRandomArrayElement(items));
            }
            return pool;
        }

        private static function generateLinearPool(total:int,  items:Array):Array
        {
            var pool:Array = [];
            var counter:int = 0;
            var totalItems:int = items.length
            var i:int;
            for (i = 0; i < total; i++)
            {
                pool.push(items[counter]);

                counter++
                if(counter >= totalItems)
                    counter = 0;
            }
            return pool;
        }

    }
}

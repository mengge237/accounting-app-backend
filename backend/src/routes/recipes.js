const express = require('express');
const { promisePool } = require('../config/database');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// 获取菜谱列表（包含菜系ID）
router.get('/', authenticateToken, async (req, res) => {
    const userId = req.userId;
    
    try {
        const [recipes] = await promisePool.execute(`
            SELECT 
                r.id, r.user_id, r.name, r.description, r.ingredients, r.steps,
                r.cook_time, r.difficulty, r.cover_image, r.is_default,
                r.created_at, r.updated_at,
                COALESCE(rc.cuisine_id, 0) as cuisine_id
            FROM recipes r
            LEFT JOIN recipe_cuisine rc ON r.id = rc.recipe_id
            WHERE r.user_id = 0 OR r.user_id = ?
            ORDER BY r.is_default DESC, r.created_at DESC
        `, [userId]);
        
        recipes.forEach(recipe => {
            try {
                if (recipe.ingredients && typeof recipe.ingredients === 'string') {
                    recipe.ingredients = JSON.parse(recipe.ingredients);
                }
                if (recipe.steps && typeof recipe.steps === 'string') {
                    recipe.steps = JSON.parse(recipe.steps);
                }
            } catch (e) {}
        });
        
        res.json({ success: true, recipes });
    } catch (error) {
        console.error('查询菜谱错误:', error);
        res.status(500).json({ success: false, message: '数据库错误' });
    }
});

// 获取我的菜谱
router.get('/my-recipes', authenticateToken, async (req, res) => {
    const userId = req.userId;
    
    try {
        const [recipes] = await promisePool.execute(`
            SELECT 
                r.id, r.user_id, r.name, r.description, r.ingredients, r.steps,
                r.cook_time, r.difficulty, r.cover_image, r.is_default,
                r.created_at, r.updated_at,
                COALESCE(rc.cuisine_id, 0) as cuisine_id
            FROM recipes r
            LEFT JOIN recipe_cuisine rc ON r.id = rc.recipe_id
            WHERE r.user_id = ? AND r.is_default = 0
            ORDER BY r.created_at DESC
        `, [userId]);
        
        recipes.forEach(recipe => {
            try {
                if (recipe.ingredients && typeof recipe.ingredients === 'string') {
                    recipe.ingredients = JSON.parse(recipe.ingredients);
                }
                if (recipe.steps && typeof recipe.steps === 'string') {
                    recipe.steps = JSON.parse(recipe.steps);
                }
            } catch (e) {}
        });
        
        res.json({ success: true, recipes });
    } catch (error) {
        console.error('查询我的菜谱错误:', error);
        res.status(500).json({ success: false, message: '数据库错误' });
    }
});

// 获取单个菜谱详情
router.get('/:id', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const recipeId = req.params.id;
    
    try {
        const [recipes] = await promisePool.execute(`
            SELECT 
                r.id, r.user_id, r.name, r.description, r.ingredients, r.steps,
                r.cook_time, r.difficulty, r.cover_image, r.is_default,
                r.created_at, r.updated_at,
                COALESCE(rc.cuisine_id, 0) as cuisine_id
            FROM recipes r
            LEFT JOIN recipe_cuisine rc ON r.id = rc.recipe_id
            WHERE r.id = ? AND (r.user_id = 0 OR r.user_id = ?)
        `, [recipeId, userId]);
        
        if (recipes.length === 0) {
            return res.status(404).json({ success: false, message: '菜谱不存在' });
        }
        
        const recipe = recipes[0];
        try {
            if (recipe.ingredients && typeof recipe.ingredients === 'string') {
                recipe.ingredients = JSON.parse(recipe.ingredients);
            }
            if (recipe.steps && typeof recipe.steps === 'string') {
                recipe.steps = JSON.parse(recipe.steps);
            }
        } catch (e) {}
        
        res.json({ success: true, recipe });
    } catch (error) {
        console.error('查询菜谱详情错误:', error);
        res.status(500).json({ success: false, message: '数据库错误' });
    }
});

// 添加菜谱
router.post('/', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const { name, description, ingredients, steps, cook_time, difficulty, cover_image, cuisine_id } = req.body;
    
    if (!name) {
        return res.status(400).json({ success: false, message: '菜谱名称不能为空' });
    }
    
    try {
        const [result] = await promisePool.execute(`
            INSERT INTO recipes (user_id, name, description, ingredients, steps, cook_time, difficulty, cover_image, is_default) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0)
        `, [userId, name, description || null, JSON.stringify(ingredients), JSON.stringify(steps), cook_time || null, difficulty || 'medium', cover_image || null]);
        
        const recipeId = result.insertId;
        
        if (cuisine_id && cuisine_id > 0) {
            await promisePool.execute('INSERT INTO recipe_cuisine (recipe_id, cuisine_id) VALUES (?, ?)', [recipeId, cuisine_id]);
        }
        
        res.json({ success: true, message: '添加成功', recipeId });
    } catch (error) {
        console.error('添加菜谱错误:', error);
        res.status(500).json({ success: false, message: '添加失败' });
    }
});

// 删除菜谱
router.delete('/:id', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const recipeId = req.params.id;
    
    try {
        await promisePool.execute('DELETE FROM recipe_cuisine WHERE recipe_id = ?', [recipeId]);
        const [result] = await promisePool.execute(
            'DELETE FROM recipes WHERE id = ? AND user_id = ? AND is_default = 0',
            [recipeId, userId]
        );
        
        if (result.affectedRows === 0) {
            return res.status(404).json({ success: false, message: '菜谱不存在或无权删除' });
        }
        
        res.json({ success: true, message: '删除成功' });
    } catch (error) {
        console.error('删除菜谱错误:', error);
        res.status(500).json({ success: false, message: '删除失败' });
    }
});

// 收藏菜谱
router.post('/:id/favorite', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const recipeId = req.params.id;
    
    try {
        await promisePool.execute('INSERT INTO user_favorite_recipes (user_id, recipe_id) VALUES (?, ?)', [userId, recipeId]);
        res.json({ success: true, message: '收藏成功' });
    } catch (error) {
        if (error.code === 'ER_DUP_ENTRY') {
            return res.status(400).json({ success: false, message: '已经收藏过了' });
        }
        console.error('收藏错误:', error);
        res.status(500).json({ success: false, message: '收藏失败' });
    }
});

// 取消收藏
router.delete('/:id/favorite', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const recipeId = req.params.id;
    
    try {
        await promisePool.execute('DELETE FROM user_favorite_recipes WHERE user_id = ? AND recipe_id = ?', [userId, recipeId]);
        res.json({ success: true, message: '已取消收藏' });
    } catch (error) {
        console.error('取消收藏错误:', error);
        res.status(500).json({ success: false, message: '操作失败' });
    }
});

// 获取收藏列表
router.get('/favorites/list', authenticateToken, async (req, res) => {
    const userId = req.userId;
    
    try {
        const [favorites] = await promisePool.execute(`
            SELECT r.*, ufr.favorited_at, COALESCE(rc.cuisine_id, 0) as cuisine_id
            FROM recipes r
            INNER JOIN user_favorite_recipes ufr ON r.id = ufr.recipe_id
            LEFT JOIN recipe_cuisine rc ON r.id = rc.recipe_id
            WHERE ufr.user_id = ?
            ORDER BY ufr.favorited_at DESC
        `, [userId]);
        
        favorites.forEach(recipe => {
            try {
                if (recipe.ingredients && typeof recipe.ingredients === 'string') {
                    recipe.ingredients = JSON.parse(recipe.ingredients);
                }
                if (recipe.steps && typeof recipe.steps === 'string') {
                    recipe.steps = JSON.parse(recipe.steps);
                }
            } catch (e) {}
        });
        
        res.json({ success: true, favorites });
    } catch (error) {
        console.error('查询收藏错误:', error);
        res.status(500).json({ success: false, message: '数据库错误' });
    }
});

// 更新菜谱菜系
router.put('/:id/cuisine', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const recipeId = req.params.id;
    const { cuisine_id } = req.body;
    
    try {
        const [recipes] = await promisePool.execute(
            'SELECT id FROM recipes WHERE id = ? AND (user_id = ? OR is_default = 1)',
            [recipeId, userId]
        );
        
        if (recipes.length === 0) {
            return res.status(404).json({ success: false, message: '菜谱不存在或无权访问' });
        }
        
        await promisePool.execute('DELETE FROM recipe_cuisine WHERE recipe_id = ?', [recipeId]);
        
        if (cuisine_id && cuisine_id > 0) {
            await promisePool.execute('INSERT INTO recipe_cuisine (recipe_id, cuisine_id) VALUES (?, ?)', [recipeId, cuisine_id]);
        }
        
        res.json({ success: true, message: '更新成功' });
    } catch (error) {
        console.error('更新菜系错误:', error);
        res.status(500).json({ success: false, message: '更新失败' });
    }
});

module.exports = router;
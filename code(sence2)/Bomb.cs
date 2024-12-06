using Godot;

public partial class Bomb : Area2D
{
	[Export]
	public float ExplosionRadius = 1300f;  // 爆炸半径，适合小型炸弹的范围
	[Export]
	public float Damage = 25f;             // 爆炸造成的伤害，可以根据游戏平衡调整
	[Export]
	public float ExplosionDelay = 0.1f;      // 爆炸延迟时间，给玩家一点点逃跑的时间

	private Timer _timer;
	private AnimatedSprite2D animatedSprite;

	public override void _Ready()
	{
		// 获取 AnimatedSprite2D 节点
		animatedSprite = GetNode<AnimatedSprite2D>("AnimatedSprite2D");

		_timer = GetNode<Timer>("Timer");
		_timer.WaitTime = ExplosionDelay;
		_timer.Timeout += Explode;
		_timer.Start();
	}

	private void Explode()
	{
		// 播放炸弹爆炸动画
		animatedSprite.Play("Bomb"); // 确保动画名称为“Bomb”

		//OnAnimationFinished();
	}

	public async void OnAnimationFinished()
	{
		// 处理爆炸效果
		GD.Print("爆炸！");

		// 找到在范围内的所有角色并造成伤害
		var spaces = GetTree().GetNodesInGroup("players"); // 假设角色组名为 "players"

		foreach (Node player in spaces)
		{
			if (player is CharacterBody2D character)
			{
				GD.Print("判定1成功，执行操作");
				GD.Print(player.Name);
				// 计算角色与炸弹之间的距离
				//等待
				await ToSignal(GetTree().CreateTimer(1.0f), "timeout");
				float distance = Position.DistanceTo(character.Position);
				if (distance <= ExplosionRadius)
				{
					GD.Print("判定2成功，执行操作");
					// 造成伤害
					character.Call("TakeDamage", Damage); // 这里有一个 `TakeDamage` 方法

					// 施加击退效果
					GD.Print("击退");
					Vector2 knockbackDirection = (character.Position - Position).Normalized();
					float knockbackForce = Damage / 2; // 调整冲击力
					// 直接修改角色的位置以实现击退效果
					character.Position += knockbackDirection * knockbackForce;
				}
			}
		}

		QueueFree(); // 删除炸弹节点
	}
}

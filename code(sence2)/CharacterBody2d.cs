using Godot;
using System;

public partial class CharacterBody2d : CharacterBody2D
{
	float Speed = 100.0f;
	float JumpVelocity = -400.0f;

	private AnimatedSprite2D animatedSprite;
	private PackedScene BombScene; // 声明 BombScene 变量
	private Vector2 initialPosition; // 用来存储角色的初始位置

	[Export]
	public float MaxHealth = 100f; // 最大生命值
	private float health; // 当前生命值
	private ProgressBar healthBar; // 生命值进度条

	public override void _Ready()
	{
		base._Ready();
		AddToGroup("players");//!!!!!!!!!!!!!!!!!!
		animatedSprite = GetNode<AnimatedSprite2D>("AnimatedSprite2D");

		//血条
		// 初始化生命值
		health = MaxHealth;
		// 获取进度条节点
		healthBar = GetNode<ProgressBar>("ProgressBar"); // 假设 ProgressBar 名称为 "ProgressBar"
		// 初始化进度条
		healthBar.MaxValue = MaxHealth;
		healthBar.Value = health;

		BombScene = GD.Load<PackedScene>("res://Bomb.tscn");

		// 设置角色的初始位置
		initialPosition = Position; // 记录初始位置
		GD.Print($"角色初始位置: {initialPosition}");

	}

	public override void _PhysicsProcess(double delta)
	{
		Vector2 velocity = Velocity;

		if (!IsOnFloor())
		{
			velocity += GetGravity() * (float)delta;
		}

		if (Input.IsActionJustPressed("ui_accept") && IsOnFloor())
		{
			velocity.Y = JumpVelocity;
		}

		Vector2 direction = Input.GetVector("左", "右", "上", "下");

		if (direction != Vector2.Zero)
		{
			float currentSpeed = Speed;
			if (Input.IsActionPressed("加速"))
			{
				currentSpeed = 200.0f;
			}

			velocity.X = direction.X * currentSpeed;
			velocity.Y = direction.Y * currentSpeed;

			// 播放行走动画
			if (!animatedSprite.IsPlaying())
			{
				animatedSprite.Play("walk_red");//!!!这里的代码要根据联机播放不同颜色的角色的动画
			}
		}
		else
		{
			velocity.X = Mathf.MoveToward(velocity.X, 0, Speed);
			velocity.Y = Mathf.MoveToward(velocity.Y, 0, Speed);

			// 播放站立动画
			if (!animatedSprite.IsPlaying())
			{
				animatedSprite.Play("idle_red");//!!!这里的代码要根据联机播放不同颜色的角色的动画
			}
		}

		Velocity = velocity;
		MoveAndSlide();

		// 放置炸弹
		if (Input.IsActionJustPressed("Bomb")) // 记得添加映射
		{
			GD.Print("检测到放炸弹输入");
			Place_Bomb();
		}

		// 实时打印角色位置
		//GD.Print($"当前角色位置: {Position}");
	}

	private bool canPlaceBomb = true;
	private async void Place_Bomb()
	{
		GD.Print("尝试放置炸弹...");
		if (!canPlaceBomb)
		return; // 如果不能放置炸弹，直接退出

		GD.Print("尝试放置炸弹...");
		if (BombScene != null)
			{
				var bombInstance = BombScene.Instantiate();

				if (bombInstance is Node2D bomb)
				{
					canPlaceBomb = false; // 设置不能再次放置
					GD.Print("进入成功");
					bomb.Position = Position;

					GetTree().CurrentScene.AddChild(bomb);
					GD.Print("炸弹放置成功！");
					//等待
					await ToSignal(GetTree().CreateTimer(1.0f), "timeout");
					canPlaceBomb = true; // 设置能再次放置
				}
				else
				{
					GD.Print("炸弹实例化失败，未能正确转换为 Bomb 类型");
				}
			}
		else
			{
				GD.Print("BombScene 为空，无法放置炸弹。");
			}
	}

	// 添加 TakeDamage 方法
	public void TakeDamage(float damage)
	{
		health -= damage;
		GD.Print($"当前生命值: {health}");

		// 确保健康值不低于零
		if (health < 0)
		{
			health = 0;
		}

		// 更新血条的值
		healthBar.Value = health;

		if (health <= 0)
		{
			GD.Print("角色死亡！");
			QueueFree(); // 角色死亡后移除角色，可以替换为其他逻辑
		}
	}
}

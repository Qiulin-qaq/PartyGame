using Godot;
using System;

public partial class CharacterBody2dA : CharacterBody2D
{
	float Speed = 100.0f;
	float JumpVelocity = -400.0f;

	private AnimatedSprite2D animatedSprite;
	private PackedScene BombScene; // 声明 BombScene 变量
	private PackedScene ColorScene;//声明 ColorScene 变量
	private Vector2 initialPosition; // 用来存储角色的初始位置
	private Label colorCountLabel;//用于显示实例化数量
	private int colorCount=0;//用于计数Color实例化的次数，用于比较
	
	public override void _Ready()
	{
		base._Ready();
		AddToGroup("players");//!!!!!!!!!!!!!!!!!!
		animatedSprite = GetNode<AnimatedSprite2D>("AnimatedSprite2D");

		BombScene = GD.Load<PackedScene>("res://Bomb.tscn");
		ColorScene = GD.Load<PackedScene>("res://Color.tscn");

		// 设置角色的初始位置
		initialPosition = Position; // 记录初始位置

		//获取着色数量显示的Lable
		colorCountLabel=GetNode<Label>("Label");
		UpdateColorCountLabel(); // 初始化显示数量
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

		// 输出当前Color实例化的个数
		//GD.Print($"当前 Color 实例化个数: {colorCount}");

		//进行地块变色（通过场景实现-与放置炸弹原理相同）
		if(true)//一直进行
		{
			//GD.Print("检测到角色移动");
			ChangeTileColor();
		}

		// 放置炸弹
		if (Input.IsActionJustPressed("Bomb")) // 记得添加映射
		{
			GD.Print("检测到放炸弹输入");
			Place_Bomb();
		}

		
	}

	//用于减少实例化计数
	public void RemoveColorInstance()
	{
		colorCount--;
		UpdateColorCountLabel(); // 更新标签
		//GD.Print($"轨迹消失，当前 Color 实例化个数: {colorCount}");
	}
	private async void ChangeTileColor()
	{
		GD.Print("尝试改变颜色");
		if (ColorScene != null)
		{
			var ColorInstance = ColorScene.Instantiate();

			if (ColorInstance is Node2D Color)
				{
					GD.Print("进入成功");
					Color.Position = Position;

					GetTree().CurrentScene.AddChild(Color);
					GD.Print("颜色放置成功！");
					//增加计数
					colorCount++;
					UpdateColorCountLabel(); // 更新显示
					//等待
					await ToSignal(GetTree().CreateTimer(1.0f), "timeout");
				}
			else
				{
					GD.Print("颜色实例化失败，未能正确转换为 Color 类型");
				}
		}
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
		//在玩法1中不造成伤害
	}

	private void UpdateColorCountLabel()
	{
		colorCountLabel.Text = $"当前着色数: {colorCount}"; // 更新标签文本
	}
}

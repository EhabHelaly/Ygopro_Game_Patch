--Vortex Triumph
function c11511522.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,11511509,aux.FilterBoolFunction(c11511522.filterF),1,true)
	--Inflict Grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c11511522.con)
	e1:SetLabel(LOCATION_GRAVE)
	e1:SetTarget(c11511522.tg)
	e1:SetOperation(c11511522.op)
	c:RegisterEffect(e1)
	--Inflict Field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11511510,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetLabel(LOCATION_MZONE)
	e2:SetTarget(c11511522.tg)
	e2:SetOperation(c11511522.op)
	c:RegisterEffect(e2)
end
function c11511522.filterF(c)
	return c:IsFusionSetCard(0xffa) and c:IsFusionAttribute(ATTRIBUTE_FIRE)
end
function c11511522.filter(c)
	return c:IsSetCard(0xffa) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c11511522.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION 
end
function c11511522.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local d=Duel.GetMatchingGroup(c11511522.filter,tp,e:GetLabel(),0,nil):GetClassCount(Card.GetRace)*200
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(d)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,d)
end
function c11511522.op(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetMatchingGroup(c11511522.filter,tp,e:GetLabel(),0,nil):GetClassCount(Card.GetRace)*200
	Duel.Damage(p,d,REASON_EFFECT)
end
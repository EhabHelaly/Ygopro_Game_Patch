--Dragonilian Crotan
function c11511220.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--counter permit
	c:EnableCounterPermit(0xffd)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c11511220.hspcon)
	e1:SetOperation(c11511220.hspop)
	c:RegisterEffect(e1)
	-- add counters
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c11511220.addctg)
	e2:SetOperation(c11511220.addcop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--cannot be attack target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetTarget(c11511220.tg)
	e5:SetValue(c11511220.bttg)
	c:RegisterEffect(e5)
	--pos
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_POSITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetHintTiming(0,0x1e0)
	e6:SetCountLimit(1)
	e6:SetCost(c11511220.cost)
	e6:SetTarget(c11511220.target)
	e6:SetOperation(c11511220.operation)
	c:RegisterEffect(e6)
	--destroy replace
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EFFECT_DESTROY_REPLACE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetTarget(c11511220.reptg)
	e7:SetValue(c11511220.repval)
	c:RegisterEffect(e7)

end
function c11511220.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xffd)
end
function c11511220.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetTurnPlayer()~=tp and eg:IsExists(c11511220.repfilter,1,nil,tp) end
	if e:GetHandler():IsCanRemoveCounter(tp,0xffd,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(11511220,0)) then
		e:GetHandler():RemoveCounter(tp,0xffd,1,REASON_EFFECT)
		local g=eg:Filter(c11511220.repfilter,nil,tp)
		if g:GetCount()==1 then
			e:SetLabelObject(g:GetFirst())
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local cg=g:Select(tp,1,1,nil)
			e:SetLabelObject(cg:GetFirst())
		end
		return true
	else return false end
end
function c11511220.repval(e,c)
	return c==e:GetLabelObject()
end
function c11511220.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c11511220.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENCE,POS_FACEDOWN_DEFENCE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end

function c11511220.tg(e,c)
	e:SetLabelObject(c)
	return true
end
function c11511220.bttg(e,c)
	local tc=e:GetLabelObject()
	return tc:IsFaceup() and tc:IsSetCard(0xffd) and tc:GetLevel()==4 and not tc:IsAttribute(c:GetAttribute())
end

function c11511220.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xffd,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xffd,1,REASON_COST)
end
function c11511220.spfilter(c)
	return c:IsSetCard(0xffd) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c11511220.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(c:GetControler(),c11511220.spfilter,1,nil)
end
function c11511220.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c11511220.spfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c11511220.filterAtt(c,att)
	return c:IsSetCard(0xffd) and c:IsFaceup() and c:IsAttribute(att)
end
function c11511220.getAttributesNumber(tp)
	local attributes={ATTRIBUTE_WIND,ATTRIBUTE_EARTH,ATTRIBUTE_LIGHT,ATTRIBUTE_DARK,ATTRIBUTE_WATER,ATTRIBUTE_FIRE,ATTRIBUTE_DEVINE}
	local count=0
	local att
	for att=1,7 do
		if Duel.IsExistingMatchingCard(c11511220.filterAtt,tp,LOCATION_MZONE,0,1,nil,attributes[att]) then count=count+1 end
	end
	return count
end
function c11511220.addctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,c11511220.getAttributesNumber(tp),0,0xffd)
end
function c11511220.addcop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0xffd,c11511220.getAttributesNumber(tp))
	end
end

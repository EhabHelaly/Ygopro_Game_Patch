-- Kairem Omicron
function c11511310.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xffc),1,1,aux.NonTuner(Card.IsSetCard,0xffc),1,1)
	c:EnableReviveLimit()

	-- banish from hand (Synchro Summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c11511310.conSP)
	e1:SetTarget(c11511310.tg1)
	e1:SetOperation(c11511310.op1)
	e1:SetLabel(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	-- banish from grave (Pendulum Summon)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c11511310.conSP)
	e2:SetTarget(c11511310.tg2)
	e2:SetOperation(c11511310.op2)
	e2:SetLabel(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e2)
	-- atk up (Pendulum Effect)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c11511310.tg)
	e3:SetValue(c11511310.val)
	c:RegisterEffect(e3)
	-- Pendulum Summon Counter 
	if not c11511310.global_check then
		c11511310.global_check=true
		c11511310[0]=0
		c11511310[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c11511310.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c11511310.clearop)
		Duel.RegisterEffect(ge2,0)
	end
end
function c11511310.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if bit.band(tc:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM and tc:IsSetCard(0xffc) then
			local p=tc:GetSummonPlayer()
			c11511310[p]=c11511310[p]+1
		end
		tc=eg:GetNext()
	end
end
function c11511310.clearop(e,tp,eg,ep,ev,re,r,rp)
	c11511310[0]=0
	c11511310[1]=0
end
function c11511310.conSP(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==e:GetLabel()
end
-- e3
function c11511310.tg(e,c)
	return c:IsSetCard(0xffc)
end
function c11511310.filterV(c)
	return c:IsFaceup() and c:IsSetCard(0xffc)
end
function c11511310.val(e,c)
	return Duel.GetMatchingGroupCount(c11511310.filterV,c:GetControler(),LOCATION_MZONE,0,nil)*200
end
-- e1
function c11511310.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,0,1,0,0)
end
function c11511310.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(1-tp,1)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
-- e2
function c11511310.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,0,1,0,0)
end
function c11511310.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,c11511310[tp],nil)
	if g:GetCount() then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

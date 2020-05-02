--Crystal-Horned Dragon
function c11511108.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1ffe),4,2)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11511108,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c11511108.sptg)
	e1:SetOperation(c11511108.spop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c11511108.eqtg)
	e2:SetOperation(c11511108.eqop)
	c:RegisterEffect(e2)
	--banish
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(c11511108.bancon)
	e3:SetOperation(c11511108.banop)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c11511108.negcon)
	e4:SetTarget(c11511108.negtg)
	e4:SetOperation(c11511108.negop)
	c:RegisterEffect(e4)
end
function c11511108.spfilter(c,e,tp)
	return c:IsCode(39111158) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11511108.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c11511108.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
	local b2=Duel.IsExistingMatchingCard(c11511108.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (b1 or b2) end
	if b1 and b2 then
		local opt=Duel.SelectOption(tp,aux.Stringid(11511108,1),aux.Stringid(11511108,2))
		e:SetLabel(opt)
		e:GetHandler():RemoveOverlayCard(tp,opt+1,opt+1,REASON_COST)
	elseif b1 then
		Duel.SelectOption(tp,aux.Stringid(11511108,1))
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
		e:SetLabel(0)
	else
		Duel.SelectOption(tp,aux.Stringid(11511108,2))
		e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
		e:SetLabel(1)
	end
end
function c11511108.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=nil
	if e:GetLabel()==0 then
		tc=Duel.SelectMatchingCard(tp,c11511108.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	else
		tc=Duel.SelectMatchingCard(tp,c11511108.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	end
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c11511108.filter(c)
	return c:IsFaceup() and c:IsCode(39111158)
end
function c11511108.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c11511108.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c11511108.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c11511108.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c11511108.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetLabelObject(tc)
	e1:SetValue(c11511108.eqlimit)
	c:RegisterEffect(e1)
end
function c11511108.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c11511108.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetEquipTarget()
		return c:GetAttack()>500 and Duel.IsChainNegatable(ev) and  ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c11511108.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c11511108.negop(e,tp,eg,ep,ev,re,r,rp)
	local q=e:GetHandler():GetEquipTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(-500)
	if q:RegisterEffect(e1) then
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	end
end
function c11511108.bancon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_SZONE)
end
function c11511108.banop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
